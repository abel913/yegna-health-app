# Plan 02: Strict Health & Wellbeing Domain Guardrails for Chatbot

## Goal Description
Restrict the conversational AI assistant strictly to adolescent health, sexual & reproductive health (SRH), puberty, bodily hygiene, mental wellbeing, substance use education, and Ethiopian youth clinic discovery. 

When users ask questions outside these health domains (e.g., "what is physics?", math problems, software coding, historical events, politics, sports trivia, cooking recipes, general school homework), the assistant must **politely refuse** to answer or define the forbidden topic, and guide the user back to health, puberty, and wellbeing topics in both **English and Amharic**.

---

## Domain Boundaries

### Permitted Topics
- Adolescent growth, puberty changes, body changes, menstrual health, hygiene, body odor.
- Sexual and Reproductive Health (SRH), contraception, family planning, consent, safe sex practices.
- HIV/AIDS prevention (PrEP, PEP, condoms), STI symptoms, testing modalities (PITC, VCT), ART treatment.
- Mental health, stress, anxiety, depression, emotional resilience, peer pressure, loneliness.
- Gender-based violence (GBV) awareness, reporting, and survivor safeguarding.
- Substance abuse risks (alcohol, khat, tobacco, shisha, drugs) and counseling support.
- Ethiopian adolescent-friendly clinics, FGAE youth centers, hospital SRH units, and national emergency lines (952 / 8335).

### Strictly Forbidden Topics (Mandatory Refusal)
- Hard sciences (physics, chemistry, biology outside human anatomy/physiology, astronomy, geology).
- Mathematics, arithmetic, calculus, geometry.
- Computer science, software coding, technology, electronics.
- Politics, elections, governments, geopolitical conflicts.
- General trivia, celebrity gossip, pop culture, entertainment, gaming.
- Food recipes, general vehicle maintenance, commercial shopping, finance/crypto.
- School homework or essay writing on non-health topics.

---

## Technical Implementation

### 1. Remote Supabase Edge Function (`supabase/functions/ask-assistant/index.ts`)
- Added explicit negative refusal directives to Gemini's system instructions:
  - *"You are strictly and solely an adolescent health, sexual & reproductive health (SRH), and mental wellbeing assistant for Ethiopian youth."*
  - *"If the user asks ANY question outside of health, puberty, reproductive anatomy, mental health, substance abuse, or healthcare clinic guidance (such as physics, mathematics, chemistry, coding, history, politics, sports, entertainment, recipes, general trivia, or school homework), you MUST POLITELY DECLINE to answer."*
  - *"Do not explain, define, or summarize the non-health topic. Simply state your dedicated health role and invite them to ask about health, puberty, or wellbeing."*
- Deployed to remote Supabase project `oflkhtjskpsedsuczfkj`.

### 2. On-Device Knowledge Engine (`lib/src/chatbot/local_curriculum_chatbot_repository.dart`)
- Implemented intent analysis in the local curriculum repository:
  - Distinguishes friendly greetings ("hi", "hello", "ሰላም", "ጤና ይስጥልኝ") from non-health inquiries.
  - Detects non-health trigger patterns (physics, math, coding, politics, recipes, weather, etc.).
  - Returns standard polite refusal and guidance messages:
    - **English**: *"I specialize strictly in adolescent health, sexual & reproductive health (SRH), puberty, mental wellbeing, and youth clinic guidance in Ethiopia. I cannot answer questions about general science, mathematics, coding, politics, or other non-health topics. Feel free to ask me anything about your physical growth, reproductive health, emotional wellbeing, or where to find youth clinics!"*
    - **Amharic**: *"እኔ የተዘጋጀሁት በኢትዮጵያ የወጣቶች ጤና፣ የሥነ-ተዋልዶ ጤና (SRH)፣ የጉርምስና ለውጦች፣ አዕምሯዊ ጤንነት እና የጤና አገልግሎቶች ላይ ብቻ መረጃ ለመስጠት ነው። ስለ ፊዚክስ፣ ሂሳብ፣ ኮዲንግ ወይም ከጤና ውጭ የሆኑ ርዕሶች ላይ መመለስ አልችልም። ስለ አካላዊ እድገትዎ፣ ሥነ-ተዋልዶ ጤና ወይም ክሊኒኮች ማንኛውንም ጥያቄ መጠየቅ ይችላሉ!"*

---

## Verification & Results
- Verified live against "what is physics": polite refusal received without defining physics.
- Verified live against "ስለ ፊዚክስ ንገረኝ": polite Amharic refusal received.
- Verified live against "What is HIV?": comprehensive grounded clinical guidance received.
