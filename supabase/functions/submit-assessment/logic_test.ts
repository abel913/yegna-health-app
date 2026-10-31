import {
  fingerprint,
  firstForwardedIp,
  hasDuplicateQuestion,
  hasUserBearer,
  isSubmission,
  readBoundedBody,
  type Submission,
} from "./logic.ts";

const validSubmission: Submission = {
  versionId: "ab4a2ac5-5a2b-4c1f-8e87-2a6f04d95111",
  locale: "en",
  requestId: "d6fdde93-10a1-4fc3-8ca7-d4741e9688e7",
  syncProgress: false,
  answers: [
    {
      questionId: "d241f8f4-f25b-48c1-9f83-b6239e11d777",
      optionId: "80ab795e-e469-4154-8557-38d68a71c30f",
    },
    {
      questionId: "9735b781-599e-46ea-8af7-40f49766d83f",
      optionId: "75e04291-0a6b-4fa6-aeca-41d5a997d918",
    },
  ],
};

Deno.test("guest submissions need no user identifier and accept bounded answers", () => {
  if (!isSubmission(validSubmission)) {
    throw new Error("Expected valid guest submission.");
  }
  if (validSubmission.syncProgress) {
    throw new Error("Guest fixture must not request sync.");
  }
});

Deno.test("guest API-key bearer is not mistaken for a Supabase user session", () => {
  if (hasUserBearer(null, "publishable-key")) {
    throw new Error("Missing auth became a user.");
  }
  if (hasUserBearer("Bearer publishable-key", "publishable-key")) {
    throw new Error("Guest API-key bearer became a user.");
  }
  if (!hasUserBearer("Bearer user-access-token", "publishable-key")) {
    throw new Error("A user session was treated as a guest.");
  }
  if (!hasUserBearer("malformed", "publishable-key")) {
    throw new Error("Malformed authorization was silently accepted as guest.");
  }
});

Deno.test("guest rate limit uses only the first forwarded client address", () => {
  if (firstForwardedIp("203.0.113.4, 10.0.0.2") !== "203.0.113.4") {
    throw new Error("Expected the first forwarded address.");
  }
  if (firstForwardedIp(null) !== null || firstForwardedIp("  ") !== null) {
    throw new Error("Missing forwarded addresses must fail closed.");
  }
});

Deno.test("invalid locales, malformed identifiers and more than 50 answers are rejected", () => {
  if (isSubmission({ ...validSubmission, locale: "fr" })) {
    throw new Error("Locale accepted.");
  }
  if (isSubmission({ ...validSubmission, requestId: "not-a-uuid" })) {
    throw new Error("UUID accepted.");
  }
  const tooMany = {
    ...validSubmission,
    answers: Array.from({ length: 51 }, (_, index) => ({
      questionId: `d241f8f4-f25b-48c1-9f83-${String(index).padStart(12, "0")}`,
      optionId: "80ab795e-e469-4154-8557-38d68a71c30f",
    })),
  };
  if (isSubmission(tooMany)) {
    throw new Error("Oversized question set accepted.");
  }
});

Deno.test("duplicate question selections are rejected", () => {
  if (!isSubmission(validSubmission)) throw new Error("Fixture invalid.");
  const duplicate = [validSubmission.answers[0], validSubmission.answers[0]];
  if (!hasDuplicateQuestion(duplicate)) {
    throw new Error("Duplicate question accepted.");
  }
});

Deno.test("fingerprint is stable for reordered answers and changes with payload", async () => {
  if (!isSubmission(validSubmission)) throw new Error("Fixture invalid.");
  const reordered: Submission = {
    ...validSubmission,
    answers: [...validSubmission.answers].reverse(),
  };
  if (await fingerprint(validSubmission) !== await fingerprint(reordered)) {
    throw new Error("Answer order changed the submission fingerprint.");
  }
  const changed: Submission = {
    ...validSubmission,
    answers: validSubmission.answers.map((answer, index) =>
      index === 0
        ? { ...answer, optionId: "7055553b-6c40-45c9-9006-37df8bc547a2" }
        : answer
    ),
  };
  if (await fingerprint(validSubmission) === await fingerprint(changed)) {
    throw new Error("Changed answer kept the same fingerprint.");
  }
});

Deno.test("request body reader stops after the configured size limit", async () => {
  const tooLarge = new Request("http://localhost/submit", {
    method: "POST",
    body: "x".repeat(40_000),
  });
  if (await readBoundedBody(tooLarge, 32_000) !== null) {
    throw new Error("Body larger than the limit was accepted.");
  }
  const accepted = new Request("http://localhost/submit", {
    method: "POST",
    body: "small",
  });
  if ((await readBoundedBody(accepted, 32_000))?.length !== 5) {
    throw new Error("Body below the limit was rejected.");
  }
});
