import React, { useState, KeyboardEvent } from 'react';
import { Tag, Plus, X } from 'lucide-react';

interface TagInputManagerProps {
  tags: string[];
  onChange: (tags: string[]) => void;
  lang?: 'en' | 'am';
}

const COMMON_SUGGESTIONS = [
  '#Youth_Friendly',
  '#Student_Clinic',
  '#MentalHealth',
  '#SRH_Counseling',
  '#First_Aid',
  '#HIV_VCT',
  '#Emergency_Care',
  '#Peer_Support',
  '#Gender_Inclusion',
  '#Disability_Access',
  '#Quiet_Study',
  '#Free_Condoms',
  '#Open_Late',
];

export const TagInputManager: React.FC<TagInputManagerProps> = ({
  tags,
  onChange,
  lang = 'en',
}) => {
  const [inputValue, setInputValue] = useState('');

  const normalizeTag = (val: string) => {
    let t = val.trim();
    if (!t) return '';
    if (!t.startsWith('#')) t = `#${t}`;
    return t.replace(/\s+/g, '_');
  };

  const handleAddTag = (rawTag: string) => {
    const formatted = normalizeTag(rawTag);
    if (!formatted) return;
    if (!tags.includes(formatted)) {
      onChange([...tags, formatted]);
    }
    setInputValue('');
  };

  const handleRemoveTag = (tagToRemove: string) => {
    onChange(tags.filter((t) => t !== tagToRemove));
  };

  const handleKeyDown = (e: KeyboardEvent<HTMLInputElement>) => {
    if (e.key === 'Enter' || e.key === ',') {
      e.preventDefault();
      handleAddTag(inputValue);
    } else if (e.key === 'Backspace' && !inputValue && tags.length > 0) {
      handleRemoveTag(tags[tags.length - 1]);
    }
  };

  return (
    <div className="space-y-2">
      <label className="block font-bold text-slate-700 dark:text-slate-300 text-xs flex items-center justify-between">
        <span className="flex items-center gap-1.5">
          <Tag size={13} className="text-slate-400 dark:text-slate-500" />
          <span>{lang === 'am' ? 'አገልግሎቶችና መለያዎች (Services & Tags)' : 'Services & Facility Tags'}</span>
        </span>
        <span className="text-[10px] text-slate-400 font-normal">
          {lang === 'am' ? 'በቀላሉ ጠቅ በማድረግ ያክሉ' : 'Click suggestions or type custom tag'}
        </span>
      </label>

      {/* Tag Chips Container with Embedded Input */}
      <div className="min-h-[42px] p-1.5 bg-slate-50 dark:bg-slate-800/80 border border-slate-200 dark:border-slate-700 rounded-xl flex flex-wrap items-center gap-1.5 focus-within:bg-white dark:focus-within:bg-slate-800 focus-within:border-brand-500 focus-within:ring-1 focus-within:ring-brand-500/20 transition-all">
        {tags.map((t) => (
          <span
            key={t}
            className="inline-flex items-center gap-1 px-2.5 py-1 rounded-lg bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-700 text-slate-800 dark:text-slate-200 text-xs font-semibold shadow-2xs group"
          >
            <span>{t}</span>
            <button
              type="button"
              onClick={() => handleRemoveTag(t)}
              className="text-slate-400 hover:text-rose-500 p-0.5 rounded transition-colors cursor-pointer"
              title="Remove tag"
            >
              <X size={11} />
            </button>
          </span>
        ))}

        <input
          type="text"
          value={inputValue}
          onChange={(e) => setInputValue(e.target.value)}
          onKeyDown={handleKeyDown}
          onBlur={() => inputValue && handleAddTag(inputValue)}
          placeholder={tags.length === 0 ? (lang === 'am' ? 'መለያ ጽፈው Enter ይጫኑ...' : 'Type tag and press Enter...') : '+ Add more...'}
          className="flex-1 min-w-[120px] bg-transparent text-xs text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-500 px-2 py-1 focus:outline-hidden"
        />
      </div>

      {/* 1-Click Suggestions Chips */}
      <div className="flex flex-wrap items-center gap-1 pt-0.5">
        <span className="text-[10px] font-bold text-slate-400 dark:text-slate-500 uppercase tracking-wider mr-1">
          {lang === 'am' ? 'ፈጣን ጥቆማዎች:' : 'Quick Tags:'}
        </span>
        {COMMON_SUGGESTIONS.map((s) => {
          const isSelected = tags.includes(s);
          return (
            <button
              key={s}
              type="button"
              onClick={() => (isSelected ? handleRemoveTag(s) : handleAddTag(s))}
              className={`inline-flex items-center gap-1 px-2 py-0.5 rounded-md text-[10px] font-semibold transition-all cursor-pointer ${
                isSelected
                  ? 'bg-slate-900 dark:bg-white text-white dark:text-slate-900 shadow-2xs'
                  : 'bg-white dark:bg-slate-800 text-slate-600 dark:text-slate-400 border border-slate-200/80 dark:border-slate-700 hover:border-slate-300 dark:hover:border-slate-600'
              }`}
            >
              {isSelected ? <X size={9} /> : <Plus size={9} />}
              <span>{s}</span>
            </button>
          );
        })}
      </div>
    </div>
  );
};
