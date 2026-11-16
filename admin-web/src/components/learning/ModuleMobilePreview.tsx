import React, { useState } from 'react';
import {
  ChevronLeft,
  Clock,
  Lightbulb,
  CheckCircle2,
  ChevronDown,
  ChevronUp,
  Check,
  ShieldCheck,
  HelpCircle,
} from 'lucide-react';

interface ParsedSection {
  title: string;
  body: string;
  bullets: string[];
  note: string | null;
}

interface ModuleMobilePreviewProps {
  title: string;
  summary: string;
  content: string;
  doctorNote?: string;
  imageUrl?: string;
  authorName?: string;
  readTimeMin?: number;
  category?: string;
  lang?: 'en' | 'am';
}

export const ModuleMobilePreview: React.FC<ModuleMobilePreviewProps> = ({
  title,
  summary,
  content,
  doctorNote,
  imageUrl,
  authorName,
  readTimeMin = 4,
  lang = 'en',
}) => {
  const [expandedSections, setExpandedSections] = useState<number[]>([0]);
  const [readSections, setReadSections] = useState<number[]>([0]);

  // Parse markdown content into structured sections matching mobile DynamicModuleDetailPage
  const sections: ParsedSection[] = React.useMemo(() => {
    if (!content || !content.trim()) {
      return [
        {
          title: lang === 'am' ? 'የትምህርት ይዘት' : 'Curriculum Guidance',
          body:
            lang === 'am'
              ? 'ይህ የጤና ሞጁል በባለሙያዎች የተዘጋጀ የወጣቶች የትምህርት መመሪያ ነው።'
              : 'This health module provides verified youth health guidance.',
          bullets: [],
          note: null,
        },
      ];
    }

    const rawBlocks = content.split(/\r?\n##\s+/);
    const result: ParsedSection[] = [];

    rawBlocks.forEach((block, idx) => {
      const trimmed = block.trim();
      if (!trimmed) return;

      const lines = trimmed.split(/\r?\n/);
      const firstLine = lines[0].replace(/^#+\s*/, '').trim();
      const bodyLines = lines.slice(1);

      const prose: string[] = [];
      const bullets: string[] = [];
      let note: string | null = null;

      bodyLines.forEach((l) => {
        const line = l.trim();
        if (!line) return;
        if (line.startsWith('- ') || line.startsWith('* ')) {
          bullets.push(line.substring(2).trim());
        } else if (line.startsWith('> ')) {
          note = line.substring(2).trim();
        } else {
          prose.push(line);
        }
      });

      result.push({
        title:
          firstLine ||
          (lang === 'am' ? `ክፍል ${idx + 1}` : `Section ${idx + 1}`),
        body: prose.join('\n\n'),
        bullets,
        note,
      });
    });

    if (result.length === 0) {
      result.push({
        title: lang === 'am' ? 'የትምህርት ይዘት' : 'Curriculum Guidance',
        body: content,
        bullets: [],
        note: null,
      });
    }

    return result;
  }, [content, lang]);

  const toggleSection = (idx: number) => {
    setReadSections((prev) => (prev.includes(idx) ? prev : [...prev, idx]));
    setExpandedSections((prev) =>
      prev.includes(idx) ? prev.filter((i) => i !== idx) : [...prev, idx]
    );
  };

  // Resolve preview image path
  const resolvedImgUrl = React.useMemo(() => {
    if (!imageUrl) return '/illustrations/module_01_puberty.jpg';
    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      return imageUrl;
    }
    // Asset path like assets/images/learning/module_01_puberty.jpg
    const filename = imageUrl.split('/').pop();
    return `/illustrations/${filename}`;
  }, [imageUrl]);

  return (
    <div className="w-full flex justify-center py-2">
      {/* Mobile Device Frame */}
      <div className="w-[360px] sm:w-[380px] bg-slate-900 rounded-[44px] p-3 shadow-2xl ring-1 ring-slate-800">
        {/* Dynamic Island / Speaker Notch */}
        <div className="w-full flex justify-center mb-1.5 pt-1">
          <div className="w-24 h-4 bg-black rounded-full flex items-center justify-center">
            <div className="w-2.5 h-2.5 rounded-full bg-slate-900/80 mr-2" />
            <div className="w-2 h-2 rounded-full bg-slate-800" />
          </div>
        </div>

        {/* Inner Phone Screen */}
        <div className="bg-[#F4F9FD] rounded-[36px] overflow-hidden border border-slate-200/50 shadow-inner flex flex-col h-[650px] relative">
          {/* Status Bar */}
          <div className="px-6 pt-2 pb-1 flex items-center justify-between text-[11px] font-bold text-slate-800">
            <span>12:25 PM</span>
            <div className="flex items-center gap-1.5">
              <span className="text-[10px] tracking-tight">5G</span>
              <div className="w-4 h-2 border border-slate-700 rounded-xs p-0.5 flex items-center">
                <div className="h-full w-full bg-slate-800 rounded-2xs" />
              </div>
            </div>
          </div>

          {/* Top App Bar (Matching Image 2) */}
          <div className="px-4 py-2.5 flex items-center justify-between border-b border-slate-100 bg-[#F4F9FD]/95 backdrop-blur-xs sticky top-0 z-10">
            <button
              type="button"
              className="p-1 rounded-full text-[#005A71] hover:bg-slate-200/60"
            >
              <ChevronLeft size={22} className="stroke-[2.5]" />
            </button>
            <h1 className="text-sm font-extrabold text-[#005A71] tracking-tight">
              {lang === 'am' ? 'የትምህርት ሞጁል' : 'Learning Modules'}
            </h1>
            <div className="flex items-center gap-1 px-2.5 py-1 bg-[#E0F2FE] rounded-lg text-[10px] font-extrabold text-[#0284C7]">
              <Clock size={12} />
              <span>{readTimeMin} MIN</span>
            </div>
          </div>

          {/* Scrollable Content Container (Matching Image 2) */}
          <div className="flex-1 overflow-y-auto px-4 py-3 space-y-4 scrollbar-thin">
            {/* 1. Top Hero Card (Matching Image 2) */}
            <div className="bg-white rounded-[22px] border border-[#BAE6FD] p-4 shadow-xs">
              <div className="w-full flex justify-center mb-3">
                <img
                  src={resolvedImgUrl}
                  alt={title}
                  className="h-40 max-w-full object-contain rounded-xl"
                  onError={(e) => {
                    // Fallback to default illustration if image fails
                    (e.target as HTMLImageElement).src =
                      '/illustrations/module_01_puberty.jpg';
                  }}
                />
              </div>

              <h2 className="text-[17px] font-extrabold text-[#08264A] leading-tight mb-2">
                {title ||
                  (lang === 'am' ? 'የሞጁሉ ርዕስ እዚህ ይታያል' : 'Module Title Goes Here')}
              </h2>

              <p className="text-[12.5px] text-[#475569] leading-relaxed mb-3">
                {summary ||
                  (lang === 'am'
                    ? 'ስለ ሞጁሉ የተዘጋጀው አጭር ማጠቃለያ እዚህ ላይ ይቀርባል...'
                    : 'Module summary description will appear here as authored by the medical team...')}
              </p>

              {authorName && (
                <div className="flex items-center gap-1.5 pt-2 border-t border-slate-100 text-[11px] font-semibold text-[#0369A1]">
                  <ShieldCheck size={13} className="text-[#0284C7]" />
                  <span className="truncate">{authorName}</span>
                </div>
              )}
            </div>

            {/* 2. Doctor's Note Container (Matching Image 2) */}
            <div className="space-y-1.5">
              <div className="flex items-center gap-2">
                <div className="w-1 h-3.5 bg-[#0284C7] rounded-full" />
                <span className="text-[14px] font-extrabold text-[#08264A]">
                  {lang === 'am' ? 'የዶክተር ማስታወሻ' : 'Note'}
                </span>
              </div>

              <div className="bg-[#EFF7FD] border border-[#CFE5F7] rounded-[18px] p-3.5 flex items-start gap-3">
                <div className="w-8 h-8 rounded-full bg-[#D8EDFB] flex items-center justify-center shrink-0">
                  <Lightbulb size={16} className="text-[#0284C7]" />
                </div>
                <p className="text-[12px] text-[#1E3A5F] font-medium leading-relaxed">
                  {doctorNote ||
                    (lang === 'am'
                      ? 'እያንዳንዱ ታዳጊ በራሱ ተፈጥሯዊ ፍጥነት ያድጋል፤ ንፅህናን መጠበቅና በራስ መተማመንን ማዳበር ጤናማ ሽግግርን ያረጋግጣል።'
                      : 'Every adolescent experiences puberty at their own unique pace—practicing good hygiene, understanding bodily changes, and embracing self-confidence helps ensure a healthy transition.')}
                </p>
              </div>
            </div>

            {/* 3. Learning Sections (Matching Image 2) */}
            <div className="space-y-2.5">
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-2">
                  <div className="w-1 h-3.5 bg-[#0284C7] rounded-full" />
                  <span className="text-[14px] font-extrabold text-[#08264A]">
                    {lang === 'am' ? 'የትምህርት ክፍሎች' : 'Learning Sections'}
                  </span>
                </div>
                <div className="px-2.5 py-0.5 bg-[#E0F2FE] rounded-full text-[10.5px] font-extrabold text-[#0284C7]">
                  {readSections.length} / {sections.length}{' '}
                  {lang === 'am' ? 'ተነቧል' : 'read'}
                </div>
              </div>

              {/* Dynamic Expandable Accordion Cards */}
              <div className="space-y-2">
                {sections.map((sec, idx) => {
                  const isExpanded = expandedSections.includes(idx);
                  const isRead = readSections.includes(idx);

                  return (
                    <div
                      key={idx}
                      className="bg-white rounded-2xl border border-slate-200/90 shadow-2xs overflow-hidden transition-all"
                    >
                      {/* Accordion Header */}
                      <button
                        type="button"
                        onClick={() => toggleSection(idx)}
                        className="w-full px-3.5 py-3 flex items-center justify-between gap-2.5 text-left hover:bg-slate-50/50 cursor-pointer"
                      >
                        <div className="flex items-center gap-2.5 min-w-0">
                          <div
                            className={`w-6 h-6 rounded-full flex items-center justify-center shrink-0 transition-colors ${
                              isRead
                                ? 'bg-[#0284C7] text-white'
                                : 'border border-slate-300 text-transparent'
                            }`}
                          >
                            <Check size={13} className="stroke-[3]" />
                          </div>
                          <span className="text-[13px] font-extrabold text-[#08264A] truncate">
                            {sec.title}
                          </span>
                        </div>
                        {isExpanded ? (
                          <ChevronUp size={16} className="text-[#0284C7] shrink-0" />
                        ) : (
                          <ChevronDown size={16} className="text-slate-400 shrink-0" />
                        )}
                      </button>

                      {/* Accordion Body */}
                      {isExpanded && (
                        <div className="px-4 pb-3.5 pt-1 border-t border-slate-100 text-[12px] text-[#334155] space-y-2.5 animate-in fade-in duration-150">
                          {sec.body && (
                            <p className="leading-relaxed whitespace-pre-line text-[#475569]">
                              {sec.body}
                            </p>
                          )}

                          {sec.bullets.length > 0 && (
                            <ul className="space-y-1.5 pl-1">
                              {sec.bullets.map((b, bIdx) => (
                                <li
                                  key={bIdx}
                                  className="flex items-start gap-2 text-[#334155] leading-relaxed"
                                >
                                  <div className="w-1.5 h-1.5 rounded-full bg-[#0284C7] mt-1.5 shrink-0" />
                                  <span>{b}</span>
                                </li>
                              ))}
                            </ul>
                          )}

                          {sec.note && (
                            <div className="bg-[#F0FDF4] border border-[#BBF7D0] rounded-xl p-2.5 flex items-start gap-2 mt-2">
                              <CheckCircle2
                                size={15}
                                className="text-[#16A34A] shrink-0 mt-0.5"
                              />
                              <p className="text-[11.5px] font-medium text-[#166534] leading-relaxed">
                                {sec.note}
                              </p>
                            </div>
                          )}
                        </div>
                      )}
                    </div>
                  );
                })}
              </div>
            </div>

            {/* Bottom Actions Card Mockup */}
            <div className="pt-2 space-y-2">
              <div className="bg-white rounded-2xl border border-slate-200/90 p-3 flex items-center justify-between shadow-2xs">
                <div className="flex items-center gap-2.5">
                  <div className="w-8 h-8 rounded-xl bg-amber-50 text-amber-600 flex items-center justify-center">
                    <HelpCircle size={16} />
                  </div>
                  <div>
                    <h4 className="text-[12px] font-extrabold text-slate-800">
                      {lang === 'am' ? 'የእውቀት መፈተሻ ፈተና' : 'Knowledge Check Quiz'}
                    </h4>
                    <p className="text-[10px] text-slate-400">
                      {lang === 'am' ? '2 ጥያቄዎች • 2 ደቂቃ' : '2 Questions • 2 Minutes'}
                    </p>
                  </div>
                </div>
                <span className="px-2.5 py-1 bg-brand-50 text-brand-700 text-[10px] font-extrabold rounded-lg">
                  {lang === 'am' ? 'ጀምር' : 'Start'}
                </span>
              </div>

              <div className="w-full py-2.5 bg-[#005A71] rounded-xl text-center text-white text-xs font-bold shadow-xs">
                {lang === 'am' ? 'ትምህርቱን አጠናቅቄአለሁ' : 'Mark Module Completed'}
              </div>
            </div>

            {/* Bottom Spacing */}
            <div className="h-4" />
          </div>

          {/* Bottom Home Indicator Bar */}
          <div className="w-full flex justify-center py-1.5 bg-[#F4F9FD]">
            <div className="w-32 h-1 bg-slate-900/60 rounded-full" />
          </div>
        </div>
      </div>
    </div>
  );
};
