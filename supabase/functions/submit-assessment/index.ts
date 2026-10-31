import {
  fingerprint,
  firstForwardedIp,
  hasDuplicateQuestion,
  hasUserBearer,
  isSubmission,
  readBoundedBody,
  type Submission,
} from "./logic.ts";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, apikey, content-type, x-client-info",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

function json(status: number, body: Record<string, unknown>): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });
}

Deno.serve(async (request: Request) => {
  if (request.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }
  if (request.method !== "POST") {
    return json(405, { error: "method_not_allowed" });
  }

  const apiKey = request.headers.get("apikey");
  const authorization = request.headers.get("authorization");
  if (!apiKey) return json(401, { error: "api_key_required" });

  const url = Deno.env.get("SUPABASE_URL");
  const serviceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
  if (!url || !serviceKey) return json(503, { error: "service_unavailable" });

  let userId: string | null = null;
  if (hasUserBearer(authorization, apiKey)) {
    if (authorization === null) return json(401, { error: "invalid_session" });
    const match = /^Bearer\s+(.+)$/i.exec(authorization);
    if (!match) return json(401, { error: "invalid_session" });
    let identityResponse: Response;
    try {
      identityResponse = await fetch(`${url}/auth/v1/user`, {
        headers: {
          apikey: apiKey,
          Authorization: `Bearer ${match[1]}`,
        },
      });
    } catch {
      return json(503, { error: "service_unavailable" });
    }
    if (!identityResponse.ok) return json(401, { error: "invalid_session" });
    const user = await identityResponse.json() as { id?: unknown };
    if (typeof user.id !== "string" || !user.id) {
      return json(401, { error: "invalid_session" });
    }
    userId = user.id;
  }

  let value: unknown;
  try {
    const bytes = await readBoundedBody(request, 32_000);
    if (bytes === null) return json(413, { error: "submission_too_large" });
    value = JSON.parse(new TextDecoder().decode(bytes));
  } catch {
    return json(400, { error: "invalid_request" });
  }
  if (!isSubmission(value)) return json(400, { error: "invalid_submission" });
  const submission = value;
  if (hasDuplicateQuestion(submission.answers)) {
    return json(400, { error: "duplicate_question" });
  }

  if (userId === null) {
    const clientIp = firstForwardedIp(request.headers.get("x-forwarded-for"));
    if (!clientIp) return json(503, { error: "rate_limit_unavailable" });
    let limitResponse: Response;
    try {
      limitResponse = await fetch(
        `${url}/rest/v1/rpc/consume_guest_assessment_rate_limit`,
        {
          method: "POST",
          headers: {
            apikey: serviceKey,
            Authorization: `Bearer ${serviceKey}`,
            "Content-Type": "application/json",
          },
          body: JSON.stringify({ p_client_ip: clientIp }),
        },
      );
    } catch {
      return json(503, { error: "rate_limit_unavailable" });
    }
    if (!limitResponse.ok) {
      return json(503, { error: "rate_limit_unavailable" });
    }
    const allowed = await limitResponse.json().catch(() => false);
    if (allowed !== true) {
      return new Response(JSON.stringify({ error: "rate_limited" }), {
        status: 429,
        headers: {
          ...corsHeaders,
          "Content-Type": "application/json",
          "Retry-After": "600",
        },
      });
    }
  }

  let scoringResponse: Response;
  try {
    scoringResponse = await fetch(`${url}/rest/v1/rpc/score_assessment`, {
      method: "POST",
      headers: {
        apikey: serviceKey,
        Authorization: `Bearer ${serviceKey}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        p_user_id: userId,
        p_version_id: submission.versionId,
        p_locale: submission.locale,
        p_request_id: submission.requestId,
        p_answers: submission.answers,
        p_payload_fingerprint: await fingerprint(submission),
        p_sync_enabled: userId !== null && submission.syncProgress,
      }),
    });
  } catch {
    return json(503, { error: "scoring_unavailable" });
  }

  if (!scoringResponse.ok) {
    const errorBody = await scoringResponse.json().catch(() => ({})) as {
      message?: string;
    };
    const message = (errorBody.message ?? "").toLowerCase();
    if (message.includes("request id already used")) {
      return json(409, { error: "submission_conflict" });
    }
    if (message.includes("disabled")) {
      return json(409, { error: "sync_preference_changed" });
    }
    if (message.includes("assessment unavailable")) {
      return json(404, { error: "assessment_unavailable" });
    }
    if (message.includes("invalid") || message.includes("incomplete")) {
      return json(400, { error: "invalid_answers" });
    }
    return json(503, { error: "scoring_unavailable" });
  }

  const result = await scoringResponse.json();
  return json(200, {
    result,
    synchronized: userId !== null && submission.syncProgress,
  });
});
