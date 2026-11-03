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
  if (!apiKey) {
    return json(401, { error: "api_key_required" });
  }

  let body: {
    prompt?: string;
    language?: string;
    history?: Array<{ role: string; parts: Array<{ text: string }> }>;
  };

  try {
    body = await request.json();
  } catch {
    return json(400, { error: "invalid_json_body" });
  }

  const prompt = (body.prompt || "").trim();
  const language = (body.language || "en").toLowerCase();

  if (!prompt) {
    return json(400, { error: "prompt_required" });
  }

  const geminiApiKey = Deno.env.get("GEMINI_API_KEY");

  // Emergency intent check
  const isEmergency = /suicide|kill myself|end my life|raped|rape|assault|assaulted|bleeding|emergency|እራሴን|መግደል|ጥቃት|አስቸኳይ/i.test(
    prompt
  );

  if (!geminiApiKey) {
    // If Gemini API Key is not set in environment, return a helpful indicator
    // so the client falls back to the on-device curriculum engine.
    return json(200, {
      answer: language.startsWith("am")
          ? "የየኛ ጤና ረዳት፡ ስለ ጉርምስና፣ ኤችአይቪ፣ አባላዘር በሽታዎች፣ ስነ-ተዋልዶ ጤና፣ ወይም በአቅራቢያዎ ያሉ የወጣቶች ክሊኒኮችን በተመለከተ ማንኛውንም ጥያቄ መጠየቅ ይችላሉ።"
          : "Yegna Health Assistant: You can ask about puberty, HIV/AIDS, STIs, reproductive health, or youth-friendly clinics in Ethiopia.",
      isEmergency,
      suggestedPrompts: language.startsWith("am")
          ? ["ኤችአይቪን እንዴት መከላከል ይቻላል?", "የጉርምስና ተፈጥሯዊ ለውጦች", "የምርመራ ክሊኒኮች የት ይገኛሉ?"]
          : ["How to prevent HIV?", "Normal puberty changes", "Where can I get tested?"],
    });
  }

  const systemInstruction = `You are the Yegna Health Assistant, an empathetic, non-judgmental, educational health assistant designed specifically for Ethiopian adolescents and youth.

STRICT HEALTH & WELLBEING DOMAIN BOUNDARY (MANDATORY NON-HEALTH REFUSAL):
- You are EXCLUSIVELY an educational health and wellbeing guide for Yegna Health.
- You must ONLY answer questions directly related to:
  1. Adolescent health, puberty milestones, bodily hygiene, menstrual health, and emotional changes in boys and girls.
  2. HIV/AIDS prevention (condoms, fidelity, PEP within 72 hours, PrEP, ART treatment, VCT testing).
  3. Sexually Transmitted Infections (STIs), symptoms (discharge, sores), and mutual partner treatment.
  4. Sexual & Reproductive Health (SRH), voluntary consent, and family planning/contraception methods.
  5. Viral Hepatitis B & C transmission, liver health, and vaccination.
  6. Mental health, stress, anxiety, depression, and emotional wellbeing.
  7. Substance abuse risks (alcohol, khat, tobacco, drugs) and healthy lifestyles.
  8. Finding verified youth-friendly clinics in Addis Ababa (FGAE, Selam, AAU, St. Paul, ALERT).
  9. Friendly greetings (e.g. "hi", "hello", "ሰላም") where you warmly welcome the user and invite them to ask about health.

CRITICAL NON-HEALTH REFUSAL RULES:
- If the user asks about ANY subject outside of human health, medicine, bodily development, reproductive education, mental wellbeing, hygiene, nutrition, substances, or youth clinics:
  * Examples of forbidden topics include: physics (e.g., "what is physics", gravity, quantum mechanics, laws of motion), mathematics, algebra, calculus, chemistry (non-medical), computer science, programming, coding, software, history, geography, politics, government, current events, wars, sports, football, music, movies, celebrity gossip, recipes, jokes, general trivia, essays, or school homework.
- YOU MUST STRICTLY REFUSE TO ANSWER OR EXPLAIN THE OUT-OF-SCOPE SUBJECT.
- NEVER explain, define, or summarize the non-health topic (e.g. DO NOT define physics, DO NOT solve equations, DO NOT write code).
- You must decline politely, firmly, and warmly, and guide the user back to health topics.
- Standard refusal phrasing in English:
  "I am designed specifically as a health, reproductive, and youth wellbeing guide for Yegna Health. I can only assist with questions regarding adolescent health, sexual & reproductive health, puberty, mental wellbeing, or youth clinic services. Please feel free to ask me any question about your health and wellbeing!"
- Standard refusal phrasing in Amharic:
  "እኔ የተዘጋጀሁት ለየኛ ጤና (Yegna Health) የጤና፣ የስነ-ተዋልዶ እና የወጣቶች ደህንነት ረዳት ሆኜ ብቻ ነው። ከጤና፣ ከጉርምስና፣ ከስነ-ተዋልዶ እና ከአእምሮ ደህንነት ውጭ ያሉ አጠቃላይ የትምህርት ወይም ሌሎች ጉዳዮችን (እንደ ፊዚክስ፣ ሂሳብ፣ ቴክኖሎጂ ወዘተ) መመለስ አልችልም። ስለ ጤናዎ፣ ስለ ጉርምስና ለውጦች፣ ስለ ኤችአይቪ/አባላዘር በሽታዎች ወይም በአቅራቢያዎ ስላሉ ክሊኒኮች ማንኛውንም ጥያቄ በደስታ መጠየቅ ይችላሉ!"

Critical Safety Rules:
- Distinguish health education from medical diagnoses or clinical prescriptions.
- If the user discusses acute physical danger, suicidal thoughts, sexual assault, or severe medical trauma, warmly provide the free national helplines: 952 (National Health Emergency) and 8335 (National Youth & Mental Health Line).
- Always answer in the requested language: ${language.startsWith("am") ? "Amharic (አማርኛ)" : "English"}.
- Be warm, encouraging, respectful, and culturally appropriate.`;

  try {
    const geminiUrl = `https://generativelanguage.googleapis.com/v1beta/models/gemini-3.5-flash-lite:generateContent?key=${geminiApiKey}`;

    const contents = [
      ...(body.history || []).map((h) => ({
        role: h.role === "user" ? "user" : "model",
        parts: h.parts || [],
      })),
      {
        role: "user",
        parts: [{ text: prompt }],
      },
    ];

    const geminiResponse = await fetch(geminiUrl, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      signal: AbortSignal.timeout(25000),
      body: JSON.stringify({
        system_instruction: {
          parts: [{ text: systemInstruction }],
        },
        contents,
        generationConfig: {
          temperature: 0.2,
          maxOutputTokens: 600,
        },
      }),
    });

    if (!geminiResponse.ok) {
      const errText = await geminiResponse.text();
      return json(502, { error: "gemini_api_error", details: errText });
    }

    const geminiData = await geminiResponse.json();
    const candidateText =
      geminiData?.candidates?.[0]?.content?.parts?.[0]?.text || "";

    return json(200, {
      answer: candidateText,
      isEmergency,
      suggestedPrompts: language.startsWith("am")
        ? ["የኤችአይቪ ምርመራ ክሊኒኮች", "የአባላዘር በሽታዎች መከላከያ", "የቤተሰብ ምጣኔ"]
        : ["Where to get tested?", "STI prevention rules", "Family planning options"],
    });
  } catch (err) {
    return json(500, {
      error: "internal_error",
      message: err instanceof Error ? err.message : String(err),
    });
  }
});
