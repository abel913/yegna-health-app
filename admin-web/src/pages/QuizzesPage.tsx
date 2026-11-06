import React, { useState } from 'react';
import {
  HelpCircle,
  Plus,
  Trash2,
  Edit2,
  CheckCircle,
  X,
} from 'lucide-react';
import { QuizQuestion, Module } from '../types/index.js';
import { ConfirmModal } from '../components/common/ConfirmModal.js';

interface QuizzesPageProps {
  questions: QuizQuestion[];
  modules: Module[];
  lang: 'en' | 'am';
  onSaveQuestion: (data: Partial<QuizQuestion>, id?: string) => Promise<void>;
  onDeleteQuestion: (id: string) => Promise<void>;
}

export const QuizzesPage: React.FC<QuizzesPageProps> = ({
  questions,
  modules,
  lang,
  onSaveQuestion,
  onDeleteQuestion,
}) => {
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingQuestion, setEditingQuestion] = useState<QuizQuestion | null>(null);
  const [questionToDelete, setQuestionToDelete] = useState<QuizQuestion | null>(null);
  const [formData, setFormData] = useState({
    moduleId: modules[0]?.id || '',
    questionEn: '',
    questionAm: '',
    optionsEn: ['', '', '', ''],
    optionsAm: ['', '', '', ''],
    correctIndex: 0,
    explanationEn: '',
    explanationAm: '',
  });

  const openCreateModal = () => {
    setEditingQuestion(null);
    setFormData({
      moduleId: modules[0]?.id || '',
      questionEn: '',
      questionAm: '',
      optionsEn: ['', '', '', ''],
      optionsAm: ['', '', '', ''],
      correctIndex: 0,
      explanationEn: '',
      explanationAm: '',
    });
    setIsModalOpen(true);
  };

  const openEditModal = (q: QuizQuestion) => {
    setEditingQuestion(q);
    setFormData({
      moduleId: q.moduleId,
      questionEn: q.questionEn,
      questionAm: q.questionAm,
      optionsEn: [...q.optionsEn],
      optionsAm: [...q.optionsAm],
      correctIndex: q.correctIndex,
      explanationEn: q.explanationEn,
      explanationAm: q.explanationAm,
    });
    setIsModalOpen(true);
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    await onSaveQuestion(formData, editingQuestion ? editingQuestion.id : undefined);
    setIsModalOpen(false);
  };

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <h2 className="text-xl md:text-2xl font-extrabold text-slate-900 flex items-center gap-2">
            <HelpCircle className="text-brand-600" size={24} />
            <span>{lang === 'am' ? 'የግንዛቤ መፈተሻ ጥያቄዎች' : 'Interactive Quizzes & Assessments'}</span>
          </h2>
          <p className="text-xs md:text-sm text-slate-500 mt-1">
            {lang === 'am'
              ? 'ለእያንዳንዱ የትምህርት ሞጁል 4 አማራጭ ያላቸውን የፈተና ጥያቄዎችና የትምህርት ማብራሪያዎችን ያስተዳድሩ።'
              : 'Create multiple-choice self-assessments with clinical explanations for students.'}
          </p>
        </div>
        <button
          onClick={openCreateModal}
          className="flex items-center gap-2 px-4 py-2.5 bg-brand-600 hover:bg-brand-700 text-white text-xs md:text-sm font-bold rounded-xl shadow-md shadow-brand-600/20 transition-all self-start sm:self-auto"
        >
          <Plus size={16} />
          <span>{lang === 'am' ? '+ አዲስ ጥያቄ ጨምር' : '+ Add Quiz Question'}</span>
        </button>
      </div>

      {/* Questions List */}
      <div className="space-y-4">
        {questions.map((q, idx) => (
          <div key={q.id} className="bg-white rounded-2xl border border-slate-200/80 p-5 shadow-xs">
            <div className="flex items-start justify-between gap-3 mb-3">
              <div className="flex items-center gap-2">
                <span className="w-6 h-6 rounded-full bg-slate-100 text-slate-700 font-bold text-xs flex items-center justify-center">
                  {idx + 1}
                </span>
                <span className="text-[10px] font-bold uppercase tracking-wider px-2 py-0.5 rounded-md bg-brand-50 text-brand-700">
                  {q.module?.category || 'Curriculum'}
                </span>
              </div>
              <div className="flex items-center gap-1">
                <button
                  onClick={() => openEditModal(q)}
                  className="p-1.5 text-slate-400 hover:text-brand-600 hover:bg-brand-50 rounded-lg transition-colors"
                  title={lang === 'am' ? 'አርትዕ' : 'Edit question'}
                >
                  <Edit2 size={15} />
                </button>
                <button
                  onClick={() => setQuestionToDelete(q)}
                  className="p-1.5 text-slate-400 hover:text-rose-600 hover:bg-rose-50 rounded-lg transition-colors cursor-pointer"
                  title={lang === 'am' ? 'ጥያቄውን ሰርዝ' : 'Delete question'}
                >
                  <Trash2 size={15} />
                </button>
              </div>
            </div>

            <h3 className="font-bold text-slate-900 text-sm mb-1">{lang === 'am' ? q.questionAm : q.questionEn}</h3>
            <p className="text-xs text-slate-400 mb-3">{lang === 'am' ? q.questionEn : q.questionAm}</p>

            {/* Options Grid */}
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-2 mb-3">
              {(lang === 'am' ? q.optionsAm : q.optionsEn).map((opt, oIdx) => (
                <div
                  key={oIdx}
                  className={`p-2.5 rounded-xl text-xs font-semibold flex items-center justify-between border ${
                    oIdx === q.correctIndex
                      ? 'bg-emerald-50/70 border-emerald-200 text-emerald-900 font-bold'
                      : 'bg-slate-50 border-slate-200/70 text-slate-700'
                  }`}
                >
                  <span>{opt}</span>
                  {oIdx === q.correctIndex && <CheckCircle size={14} className="text-emerald-600 flex-shrink-0" />}
                </div>
              ))}
            </div>

            <div className="p-3 bg-slate-50 rounded-xl text-xs text-slate-600 border border-slate-100">
              <span className="font-bold text-slate-900 block mb-0.5">
                {lang === 'am' ? 'የዶክተር ማብራሪያ፡' : 'Clinical Explanation:'}
              </span>
              {lang === 'am' ? q.explanationAm : q.explanationEn}
            </div>
          </div>
        ))}
      </div>

      {/* Modal */}
      {isModalOpen && (
        <div className="fixed inset-0 z-50 bg-slate-900/40 backdrop-blur-xs flex items-center justify-center p-4">
          <div className="bg-white rounded-3xl border border-slate-200 shadow-2xl max-w-xl w-full max-h-[90vh] overflow-y-auto p-6 md:p-8 animate-in fade-in zoom-in-95">
            <div className="flex items-center justify-between pb-3 border-b border-slate-100">
              <h3 className="text-lg font-extrabold text-slate-900">
                {editingQuestion
                  ? (lang === 'am' ? 'የፈተና ጥያቄን አርትዕ' : 'Edit Quiz Question')
                  : (lang === 'am' ? 'አዲስ የፈተና ጥያቄ ጨምር' : 'Add New Quiz Question')}
              </h3>
              <button onClick={() => setIsModalOpen(false)} className="p-1 text-slate-400 hover:text-slate-600">
                <X size={20} />
              </button>
            </div>

            <form onSubmit={handleSubmit} className="mt-4 space-y-3.5 text-xs md:text-sm">
              <div>
                <label className="block font-bold text-slate-700 mb-1">Parent Module</label>
                <select
                  value={formData.moduleId}
                  onChange={(e) => setFormData({ ...formData, moduleId: e.target.value })}
                  className="w-full px-3 py-2 border border-slate-200 rounded-xl bg-white font-medium"
                >
                  {modules.map((m) => (
                    <option key={m.id} value={m.id}>
                      {m.titleEn} ({m.category})
                    </option>
                  ))}
                </select>
              </div>

              <div>
                <label className="block font-bold text-slate-700 mb-1">Question (English)</label>
                <input
                  type="text"
                  required
                  value={formData.questionEn}
                  onChange={(e) => setFormData({ ...formData, questionEn: e.target.value })}
                  className="w-full px-3 py-2 border border-slate-200 rounded-xl"
                  placeholder="e.g. Which method protects against both pregnancy and STIs?"
                />
              </div>

              <div>
                <label className="block font-bold text-slate-700 mb-1">ጥያቄ (በአማርኛ)</label>
                <input
                  type="text"
                  required
                  value={formData.questionAm}
                  onChange={(e) => setFormData({ ...formData, questionAm: e.target.value })}
                  className="w-full px-3 py-2 border border-slate-200 rounded-xl"
                  placeholder="ምሳሌ፡ ከአባላዘር በሽታዎችና ያልተፈለገ እርግዝና የሚከላከል የትኛው ነው?"
                />
              </div>

              <div className="space-y-2 pt-2">
                <label className="block font-bold text-slate-700">4 Multiple Choice Options (English)</label>
                {formData.optionsEn.map((opt, i) => (
                  <div key={i} className="flex items-center gap-2">
                    <input
                      type="radio"
                      name="correctIdx"
                      checked={formData.correctIndex === i}
                      onChange={() => setFormData({ ...formData, correctIndex: i })}
                      title="Mark as correct answer"
                    />
                    <input
                      type="text"
                      required
                      placeholder={`Option ${i + 1}`}
                      value={opt}
                      onChange={(e) => {
                        const next = [...formData.optionsEn];
                        next[i] = e.target.value;
                        setFormData({ ...formData, optionsEn: next });
                      }}
                      className="flex-1 px-3 py-1.5 border border-slate-200 rounded-lg text-xs"
                    />
                  </div>
                ))}
              </div>

              <div className="space-y-2 pt-2">
                <label className="block font-bold text-slate-700">4 አማራጮች (በአማርኛ)</label>
                {formData.optionsAm.map((opt, i) => (
                  <div key={i} className="flex items-center gap-2">
                    <span className="text-xs text-slate-400 font-bold w-4">#{i + 1}</span>
                    <input
                      type="text"
                      required
                      placeholder={`አማራጭ ${i + 1}`}
                      value={opt}
                      onChange={(e) => {
                        const next = [...formData.optionsAm];
                        next[i] = e.target.value;
                        setFormData({ ...formData, optionsAm: next });
                      }}
                      className="flex-1 px-3 py-1.5 border border-slate-200 rounded-lg text-xs"
                    />
                  </div>
                ))}
              </div>

              <div>
                <label className="block font-bold text-slate-700 mb-1">Clinical Explanation (English)</label>
                <textarea
                  rows={2}
                  required
                  value={formData.explanationEn}
                  onChange={(e) => setFormData({ ...formData, explanationEn: e.target.value })}
                  className="w-full px-3 py-2 border border-slate-200 rounded-xl text-xs"
                />
              </div>

              <div>
                <label className="block font-bold text-slate-700 mb-1">የዶክተር ማብራሪያ (በአማርኛ)</label>
                <textarea
                  rows={2}
                  required
                  value={formData.explanationAm}
                  onChange={(e) => setFormData({ ...formData, explanationAm: e.target.value })}
                  className="w-full px-3 py-2 border border-slate-200 rounded-xl text-xs"
                />
              </div>

              <div className="pt-4 flex items-center justify-end gap-3 border-t border-slate-100">
                <button
                  type="button"
                  onClick={() => setIsModalOpen(false)}
                  className="px-4 py-2 border border-slate-200 text-slate-600 font-bold rounded-xl hover:bg-slate-50"
                >
                  Cancel
                </button>
                <button
                  type="submit"
                  className="px-5 py-2 bg-brand-600 hover:bg-brand-700 text-white font-bold rounded-xl shadow-md shadow-brand-600/20"
                >
                  {editingQuestion
                    ? (lang === 'am' ? 'ለውጦችን መዝግብ' : 'Save Changes')
                    : (lang === 'am' ? 'ጥያቄውን መዝግብ' : 'Save Question')}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
      {/* Delete Confirmation Modal */}
      <ConfirmModal
        isOpen={Boolean(questionToDelete)}
        onClose={() => setQuestionToDelete(null)}
        onConfirm={async () => {
          if (questionToDelete) {
            await onDeleteQuestion(questionToDelete.id);
          }
        }}
        title={lang === 'am' ? 'የፈተና ጥያቄው ይሰረዝ?' : 'Delete Quiz Question?'}
        itemName={questionToDelete ? (lang === 'am' ? questionToDelete.questionAm || questionToDelete.questionEn : questionToDelete.questionEn) : ''}
        message={
          lang === 'am'
            ? 'ይህ ጥያቄ ከፈተናው ማህደር በቋሚነት ይሰረዛል። ተማሪዎች ይህንን ጥያቄ በፈተና ወቅት አያገኙትም።'
            : 'This multiple-choice clinical question and its explanation will be permanently deleted from the assessment bank.'
        }
        lang={lang}
      />
    </div>
  );
};
