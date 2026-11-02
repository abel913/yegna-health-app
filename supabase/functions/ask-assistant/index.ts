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
Your goal is to provide accurate, easy-to-understand health education regarding:
1. Puberty milestones, bodily hygiene, and emotional changes in boys and girls.
2. HIV/AIDS prevention (condoms, fidelity, PEP within 72 hours, ART treatment, VCT testing).
3. Sexually Transmitted Infections (STIs), symptoms (discharge, sores), and mutual partner treatment.
4. Sexual & Reproductive Health (SRH), voluntary consent, and family planning methods.
5. Viral Hepatitis B & C transmission, liver health, and vaccination.
6. Substance abuse risks, mental health, and healthy lifestyles.
7. Finding youth-friendly clinics in Addis Ababa (FGAE, Selam, AAU, St. Paul, ALERT).

Critical Safety Rules:
- Distinguish health education from medical diagnoses or clinical prescriptions.
- If the user discusses acute physical danger, suicidal thoughts, sexual assault, or severe medical trauma, warmly provide the free national helplines: 952 (National Health Emergency) and 8335 (National Youth & Mental Health Line).
- Always answer in the requested language: ${language.startsWith("am") ? "Amharic (አማርኛ)" : "English"}.
- Be warm, encouraging, respectful, and culturally appropriate.`;

  try {
    const geminiUrl = `https://generativelanguage.googleapis.com/v1beta/models/gemini-3.8-flash:generateContent?key=${geminiApiKey}`;

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
      body: JSON.stringify({
        system_instruction: {
          parts: [{ text: systemInstruction }],
        },
        contents,
        generationConfig: {
          temperature: 0.3,
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
