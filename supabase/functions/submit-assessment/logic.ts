export type Answer = { questionId: string; optionId: string };
export type Submission = {
  versionId: string;
  locale: "en" | "am";
  requestId: string;
  answers: Answer[];
  syncProgress: boolean;
};

const uuidPattern =
  /^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i;

export function isSubmission(value: unknown): value is Submission {
  if (!value || typeof value !== "object") return false;
  const body = value as Record<string, unknown>;
  if (
    typeof body.versionId !== "string" || !uuidPattern.test(body.versionId) ||
    !["en", "am"].includes(String(body.locale)) ||
    typeof body.requestId !== "string" || !uuidPattern.test(body.requestId) ||
    typeof body.syncProgress !== "boolean" || !Array.isArray(body.answers) ||
    body.answers.length < 1 || body.answers.length > 50
  ) return false;

  return body.answers.every((answer) => {
    if (!answer || typeof answer !== "object") return false;
    const item = answer as Record<string, unknown>;
    return typeof item.questionId === "string" &&
      uuidPattern.test(item.questionId) &&
      typeof item.optionId === "string" && uuidPattern.test(item.optionId);
  });
}

export function hasDuplicateQuestion(answers: Answer[]): boolean {
  return new Set(answers.map((answer) => answer.questionId)).size !==
    answers.length;
}

export function hasUserBearer(
  authorization: string | null,
  apiKey: string,
): boolean {
  if (authorization === null) return false;
  const match = /^Bearer\s+(.+)$/i.exec(authorization);
  if (!match) return true;
  return match[1] !== apiKey;
}

export function firstForwardedIp(value: string | null): string | null {
  const candidate = value?.split(",", 1)[0]?.trim();
  return candidate && candidate.length <= 45 ? candidate : null;
}

export async function fingerprint(submission: Submission): Promise<string> {
  const sortedAnswers = [...submission.answers].sort((left, right) =>
    left.questionId.localeCompare(right.questionId)
  );
  const canonical = JSON.stringify({
    versionId: submission.versionId,
    locale: submission.locale,
    answers: sortedAnswers,
  });
  const digest = await crypto.subtle.digest(
    "SHA-256",
    new TextEncoder().encode(canonical),
  );
  return Array.from(
    new Uint8Array(digest),
    (byte) => byte.toString(16).padStart(2, "0"),
  ).join("");
}

export async function readBoundedBody(
  request: Request,
  limit: number,
): Promise<Uint8Array | null> {
  const reader = request.body?.getReader();
  if (!reader) return new Uint8Array();
  const chunks: Uint8Array[] = [];
  let length = 0;
  while (true) {
    const { done, value } = await reader.read();
    if (done) break;
    length += value.length;
    if (length > limit) {
      await reader.cancel();
      return null;
    }
    chunks.push(value);
  }
  const bytes = new Uint8Array(length);
  let offset = 0;
  for (const chunk of chunks) {
    bytes.set(chunk, offset);
    offset += chunk.length;
  }
  return bytes;
}
