import React, { useState } from 'react';
import { Download, FileText, LockKeyhole, LogOut, ShieldCheck } from 'lucide-react';
import { AdminUser, GovernmentReport } from '../types/index.js';
import { api } from '../services/api.js';
import { exportToCsv } from '../utils/csvExport.js';

interface GovernmentReportsPageProps {
  user: AdminUser;
  report: GovernmentReport | null;
  isLoading: boolean;
  error: string | null;
  onRetry: () => void;
  lang: 'en' | 'am';
  onToggleLang: () => void;
  onLogout: () => void;
  onPasswordChanged: (user: AdminUser) => void;
}

export const GovernmentReportsPage: React.FC<GovernmentReportsPageProps> = ({
  user,
  report,
  isLoading,
  error,
  onRetry,
  lang,
  onToggleLang,
  onLogout,
  onPasswordChanged,
}) => {
  const am = lang === 'am';
  const [newPassword, setNewPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [passwordError, setPasswordError] = useState<string | null>(null);
  const [isSavingPassword, setIsSavingPassword] = useState(false);

  const changePassword = async (event: React.FormEvent) => {
    event.preventDefault();
    setPasswordError(null);
    if (newPassword.length < 12) {
      setPasswordError(am ? 'የይለፍ ቃሉ ቢያንስ 12 ቁምፊዎች መሆን አለበት።' : 'Use at least 12 characters for your new password.');
      return;
    }
    if (newPassword !== confirmPassword) {
      setPasswordError(am ? 'የይለፍ ቃሎቹ አይዛመዱም።' : 'The passwords do not match.');
      return;
    }

    setIsSavingPassword(true);
    try {
      const result = await api.updatePassword(newPassword);
      setNewPassword('');
      setConfirmPassword('');
      onPasswordChanged(result.user);
    } catch {
      setPasswordError(am ? 'የይለፍ ቃሉን ማዘመን አልተሳካም። እንደገና ይሞክሩ።' : 'Password update failed. Check your connection and try again.');
    } finally {
      setIsSavingPassword(false);
    }
  };

  const exportReport = () => {
    if (!report) return;
    const rows = [
      { metric: am ? 'የተመዘገቡ ተማሪዎች' : 'Registered students', value: report.registeredStudents },
      { metric: am ? 'የተመዘገቡ አማካሪዎች' : 'Registered mentors', value: report.registeredMentors },
      { metric: am ? 'የአማካሪ መገለጫዎች' : 'Mentor profiles', value: report.mentorProfiles },
      { metric: am ? 'ጠቅላላ የጤና ተቋማት' : 'Health facilities', value: report.facilities },
      { metric: am ? 'የተረጋገጡ ተቋማት' : 'Verified facilities', value: report.verifiedFacilities },
      { metric: am ? 'ጠቅላላ ክለቦች' : 'Student clubs', value: report.clubs },
      { metric: am ? 'የጸደቁ ክለቦች' : 'Approved clubs', value: report.approvedClubs },
      { metric: am ? 'የትምህርት ሞጁሎች' : 'Learning modules', value: report.learningModules },
      { metric: am ? 'የታተሙ ሞጁሎች' : 'Published modules', value: report.publishedModules },
      { metric: am ? 'የጥያቄ ባንክ ጥያቄዎች' : 'Quiz questions', value: report.quizQuestions },
      { metric: am ? 'የሞጁል ምዘናዎች' : 'Module assessments', value: report.moduleAssessments },
      { metric: am ? 'የምዘና ጥያቄዎች' : 'Assessment questions', value: report.assessmentQuestions },
      ...report.registrationTrend.map((point) => ({
        metric: `${am ? 'ወርሃዊ የተማሪ ምዝገባ' : 'Monthly student registrations'} ${point.month}`,
        value: point.students,
      })),
      ...report.registrationTrend.map((point) => ({
        metric: `${am ? 'ወርሃዊ የአማካሪ ምዝገባ' : 'Monthly mentor registrations'} ${point.month}`,
        value: point.mentors,
      })),
      ...report.registrationTrend.map((point) => ({
        metric: `${am ? 'ጠቅላላ ወርሃዊ ምዝገባ' : 'Total monthly registrations'} ${point.month}`,
        value: point.students + point.mentors,
      })),
    ];
    exportToCsv(
      'Yegna_Health_Government_Report',
      [
        { header: am ? 'መለኪያ' : 'Metric', accessor: (row) => row.metric },
        { header: am ? 'ብዛት' : 'Count', accessor: (row) => row.value },
      ],
      rows,
    );
  };

  if (user.mustChangePassword) {
    return (
      <main className="min-h-screen bg-slate-100 dark:bg-slate-950 px-4 py-10 flex items-center justify-center">
        <form onSubmit={changePassword} className="w-full max-w-md rounded-3xl bg-white dark:bg-slate-900 p-7 shadow-xl border border-slate-200 dark:border-slate-800 space-y-5">
          <div className="w-12 h-12 rounded-2xl bg-amber-100 dark:bg-amber-950/50 text-amber-700 dark:text-amber-300 flex items-center justify-center"><LockKeyhole /></div>
          <div>
            <h1 className="text-xl font-bold text-slate-900 dark:text-white">{am ? 'አዲስ የይለፍ ቃል ያዘጋጁ' : 'Set a new password'}</h1>
            <p className="mt-2 text-sm text-slate-600 dark:text-slate-300">{am ? 'ሪፖርቶችን ከማየትዎ በፊት ጊዜያዊውን የይለፍ ቃል ይቀይሩ።' : 'Change your temporary password before opening government reports.'}</p>
          </div>
          {passwordError && <p role="alert" className="rounded-xl bg-rose-50 dark:bg-rose-950/40 p-3 text-sm text-rose-700 dark:text-rose-300">{passwordError}</p>}
          <label className="block text-sm font-medium text-slate-700 dark:text-slate-200">
            {am ? 'አዲስ የይለፍ ቃል' : 'New password'}
            <input autoComplete="new-password" type="password" minLength={12} required value={newPassword} onChange={(e) => setNewPassword(e.target.value)} className="mt-1 w-full rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-800 px-3 py-2.5" />
          </label>
          <label className="block text-sm font-medium text-slate-700 dark:text-slate-200">
            {am ? 'አዲሱን የይለፍ ቃል ያረጋግጡ' : 'Confirm new password'}
            <input autoComplete="new-password" type="password" minLength={12} required value={confirmPassword} onChange={(e) => setConfirmPassword(e.target.value)} className="mt-1 w-full rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-800 px-3 py-2.5" />
          </label>
          <div className="flex gap-3">
            <button disabled={isSavingPassword} className="flex-1 rounded-xl bg-cyan-700 px-4 py-3 font-semibold text-white disabled:opacity-60">{isSavingPassword ? (am ? 'በመቀየር ላይ…' : 'Updating…') : (am ? 'የይለፍ ቃሉን ቀይር' : 'Change password')}</button>
            <button type="button" onClick={onLogout} className="rounded-xl border border-slate-300 dark:border-slate-700 px-4 py-3 text-slate-700 dark:text-slate-200">{am ? 'ውጣ' : 'Sign out'}</button>
          </div>
        </form>
      </main>
    );
  }

  const cards = report ? [
    { title: am ? 'የተመዘገቡ ተማሪዎች' : 'Registered students', value: report.registeredStudents },
    { title: am ? 'የተመዘገቡ አማካሪዎች' : 'Registered mentors', value: report.registeredMentors },
    { title: am ? 'የአማካሪ መገለጫዎች' : 'Mentor profiles', value: report.mentorProfiles },
    { title: am ? 'የጤና ተቋማት' : 'Health facilities', value: report.facilities, detail: `${report.verifiedFacilities} ${am ? 'የተረጋገጡ' : 'verified'}` },
    { title: am ? 'የተማሪ ክለቦች' : 'Student clubs', value: report.clubs, detail: `${report.approvedClubs} ${am ? 'የጸደቁ' : 'approved'}` },
    { title: am ? 'የትምህርት ሞጁሎች' : 'Learning modules', value: report.learningModules, detail: `${report.publishedModules} ${am ? 'የታተሙ' : 'published'}` },
    { title: am ? 'የጥያቄ ባንክ ጥያቄዎች' : 'Quiz questions', value: report.quizQuestions },
    { title: am ? 'የሞጁል ምዘናዎች' : 'Module assessments', value: report.moduleAssessments, detail: `${report.assessmentQuestions} ${am ? 'ጥያቄዎች' : 'questions'}` },
  ] : [];

  return (
    <main className="min-h-screen bg-slate-100 dark:bg-slate-950 p-4 sm:p-8">
      <div className="mx-auto max-w-6xl space-y-6">
        <header className="flex flex-wrap items-center justify-between gap-4 rounded-3xl bg-slate-900 p-6 text-white">
          <div>
            <div className="mb-2 flex items-center gap-2 text-cyan-300"><ShieldCheck size={19} /><span className="text-xs font-bold uppercase tracking-wider">{am ? 'የመንግስት ተመልካች' : 'Government viewer'}</span></div>
            <h1 className="text-2xl font-bold">{am ? 'የመድረክ ሪፖርቶች' : 'Platform reports'}</h1>
            <p className="mt-1 text-sm text-slate-300">{am ? 'ለእቅድ እና ክትትል የተዘጋጁ ጠቅላላ ቁጥሮች' : 'Aggregate counts for planning and oversight'}</p>
          </div>
          <div className="flex items-center gap-2">
            <span className="hidden text-sm text-slate-300 sm:block">{user.email}</span>
            <button type="button" onClick={onToggleLang} className="rounded-xl border border-slate-600 px-3 py-2.5 text-sm font-semibold text-slate-200">{am ? 'English' : 'አማርኛ'}</button>
            <button type="button" onClick={exportReport} disabled={!report} className="inline-flex items-center gap-2 rounded-xl bg-cyan-600 px-4 py-2.5 text-sm font-semibold text-white disabled:opacity-50"><Download size={17} />{am ? 'የCSV ሪፖርት' : 'Export CSV'}</button>
            <button type="button" onClick={onLogout} aria-label={am ? 'ውጣ' : 'Sign out'} className="rounded-xl border border-slate-600 p-2.5 text-slate-200"><LogOut size={17} /></button>
          </div>
        </header>

        {isLoading && <div role="status" className="rounded-2xl bg-white dark:bg-slate-900 p-8 text-center text-slate-600 dark:text-slate-300">{am ? 'ሪፖርቶች በመጫን ላይ…' : 'Loading reports…'}</div>}
        {!isLoading && error && <div role="alert" className="flex flex-wrap items-center justify-between gap-3 rounded-2xl border border-rose-200 bg-rose-50 p-5 text-rose-800 dark:border-rose-900 dark:bg-rose-950/40 dark:text-rose-200"><span>{am ? 'ሪፖርቶችን መጫን አልተቻለም። የኢንተርኔት ግንኙነትዎን ያረጋግጡ።' : 'Reports could not be loaded. Check your connection.'}</span><button type="button" onClick={onRetry} className="rounded-lg border border-rose-300 px-3 py-1.5 text-sm font-semibold dark:border-rose-800">{am ? 'እንደገና ሞክር' : 'Try again'}</button></div>}
        {!isLoading && !error && report && <>
          <section aria-label={am ? 'የመድረክ ማጠቃለያ' : 'Platform summary'} className="grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
            {cards.map((card) => <article key={card.title} className="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm dark:border-slate-800 dark:bg-slate-900"><div className="flex items-center gap-2 text-sm font-medium text-slate-500 dark:text-slate-400"><FileText size={16} className="text-cyan-600" />{card.title}</div><p className="mt-4 text-3xl font-bold text-slate-900 dark:text-white">{card.value.toLocaleString()}</p>{card.detail && <p className="mt-1 text-xs text-slate-500 dark:text-slate-400">{card.detail}</p>}</article>)}
          </section>
          <section className="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm dark:border-slate-800 dark:bg-slate-900">
            <h2 className="text-lg font-bold text-slate-900 dark:text-white">{am ? 'የ12 ወር የተማሪ እና አማካሪ ምዝገባ' : '12-month student and mentor registrations'}</h2>
            <p className="mt-1 text-sm text-slate-500 dark:text-slate-400">{am ? 'በወር የተደመሩ ቁጥሮች ብቻ፤ የግለሰብ መረጃ አይታይም።' : 'Monthly totals only; no individual records are shown.'}</p>
            <div className="mt-4 overflow-x-auto"><table className="w-full min-w-[440px] text-left text-sm"><thead className="text-xs uppercase text-slate-500"><tr><th className="py-2">{am ? 'ወር' : 'Month'}</th><th>{am ? 'ተማሪዎች' : 'Students'}</th><th>{am ? 'አማካሪዎች' : 'Mentors'}</th><th>{am ? 'ጠቅላላ' : 'Total'}</th></tr></thead><tbody>{report.registrationTrend.map((point) => <tr key={point.month} className="border-t border-slate-100 text-slate-700 dark:border-slate-800 dark:text-slate-200"><td className="py-2.5 font-medium">{point.month}</td><td>{point.students.toLocaleString()}</td><td>{point.mentors.toLocaleString()}</td><td>{(point.students + point.mentors).toLocaleString()}</td></tr>)}</tbody></table></div>
          </section>
          <p className="text-xs text-slate-500 dark:text-slate-400">{am ? 'ይህ የእይታ መለያ ጠቅላላ ሪፖርቶችን ብቻ ይደርሳል።' : 'This view-only account can access aggregate reports only.'}</p>
        </>}
      </div>
    </main>
  );
};
