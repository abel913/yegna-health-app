import React, { useState, useMemo } from 'react';
import {
  ShieldAlert,
  UserCheck,
  UserX,
  ShieldCheck,
  GraduationCap,
  Search,
  Filter,
  Download,
  ChevronLeft,
  ChevronRight,
  X,
  Users as UsersIcon,
} from 'lucide-react';
import { ManagedUser } from '../types/index.js';
import { exportToCsv } from '../utils/csvExport.js';

interface UsersPageProps {
  users: ManagedUser[];
  lang: 'en' | 'am';
  onUpdateRole: (id: string, role: string) => Promise<void>;
  onToggleSuspension: (id: string) => Promise<void>;
}

export const UsersPage: React.FC<UsersPageProps> = ({
  users,
  lang,
  onUpdateRole,
  onToggleSuspension,
}) => {
  const [search, setSearch] = useState('');
  const [roleFilter, setRoleFilter] = useState('ALL');
  const [statusFilter, setStatusFilter] = useState<'ALL' | 'ACTIVE' | 'SUSPENDED'>('ALL');
  const [currentPage, setCurrentPage] = useState(1);
  const [pageSize, setPageSize] = useState(10);

  // 1. Filter logic
  const filteredUsers = useMemo(() => {
    return users.filter((u) => {
      const q = search.toLowerCase();
      const matchesSearch =
        u.email.toLowerCase().includes(q) ||
        (u.displayName && u.displayName.toLowerCase().includes(q));

      const matchesRole =
        roleFilter === 'ALL' ||
        u.role === roleFilter ||
        (roleFilter === 'ADMINS' && (u.role === 'ADMIN' || u.role === 'SUPER_ADMIN'));

      const matchesStatus =
        statusFilter === 'ALL' ||
        (statusFilter === 'ACTIVE' && !u.isSuspended) ||
        (statusFilter === 'SUSPENDED' && u.isSuspended);

      return matchesSearch && matchesRole && matchesStatus;
    });
  }, [users, search, roleFilter, statusFilter]);

  // Reset to page 1 whenever filters change
  const totalPages = Math.max(1, Math.ceil(filteredUsers.length / pageSize));
  const safeCurrentPage = Math.min(currentPage, totalPages);

  // 2. Pagination slice
  const paginatedUsers = useMemo(() => {
    const startIndex = (safeCurrentPage - 1) * pageSize;
    return filteredUsers.slice(startIndex, startIndex + pageSize);
  }, [filteredUsers, safeCurrentPage, pageSize]);

  // 3. Export to CSV (Zero-knowledge safe: only public roles & account status)
  const handleExportCsv = () => {
    exportToCsv(
      'Yegna_Health_User_Governance_Roster',
      [
        { header: 'Display Name', accessor: (u) => u.displayName || 'Anonymous User' },
        { header: 'Email Address', accessor: (u) => u.email },
        { header: 'Platform Role', accessor: (u) => u.role },
        { header: 'Clubs Joined', accessor: (u) => u.joinedClubCount || 0 },
        { header: 'Account Status', accessor: (u) => (u.isSuspended ? 'SUSPENDED' : 'ACTIVE') },
        { header: 'Registration Date', accessor: (u) => new Date(u.createdAt).toLocaleDateString() },
      ],
      filteredUsers
    );
  };

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <h2 className="text-xl md:text-2xl font-extrabold text-slate-900 dark:text-white flex items-center gap-2">
            <ShieldAlert className="text-brand-600 dark:text-cyan-400" size={24} />
            <span>{lang === 'am' ? 'የተጠቃሚዎች ደህንነትና የአስተዳዳሪ ሚናዎች' : 'User Safety & Role Governance'}</span>
          </h2>
          <p className="text-xs md:text-sm text-slate-500 dark:text-slate-400 mt-1">
            {lang === 'am'
              ? 'የተማሪዎችን አካውንት ሚና ያስተዳድሩ፤ የማህበረሰብ ደንቦችን የጣሱ ተጠቃሚዎችን ያግዱ ወይም ይፍቀዱ።'
              : 'Manage user permissions, elevate verified counselors/admins, and suspend abusive accounts.'}
          </p>
        </div>

        <button
          onClick={handleExportCsv}
          className="flex items-center gap-1.5 px-3.5 py-2.5 bg-slate-100 dark:bg-slate-800 hover:bg-slate-200 dark:hover:bg-slate-700 text-slate-700 dark:text-slate-200 text-xs md:text-sm font-bold rounded-xl border border-slate-200 dark:border-slate-700 transition-all cursor-pointer self-start sm:self-auto shadow-2xs"
          title={lang === 'am' ? 'የተጠቃሚዎችን ዝርዝር (CSV) አውርድ' : 'Export users to Excel CSV'}
        >
          <Download size={15} />
          <span>{lang === 'am' ? 'ሪፖርት (CSV)' : 'Export Users (CSV)'}</span>
        </button>
      </div>

      {/* Privacy Vault Guarantee Card */}
      <div className="bg-emerald-50 dark:bg-emerald-950/40 border border-emerald-200/80 dark:border-emerald-800 rounded-2xl p-4 flex items-start gap-3">
        <ShieldCheck size={22} className="text-emerald-600 dark:text-emerald-400 flex-shrink-0 mt-0.5" />
        <div>
          <h4 className="text-xs font-bold text-emerald-900 dark:text-emerald-300">
            {lang === 'am' ? 'የተማሪዎች ሚስጥራዊነት ሕግጋት (Zero-Knowledge Privacy Active)' : 'Zero-Knowledge Privacy Architecture Active'}
          </h4>
          <p className="text-[11px] text-emerald-700 dark:text-emerald-400 leading-relaxed mt-0.5">
            {lang === 'am'
              ? 'አስተዳዳሪው የመለያ ሁኔታዎችንና ሚናዎችን ብቻ ማስተዳደር ይችላል። የተማሪዎች የግል የጤና ንባብ፣ የፈተና መልሶች፣ ወይም የምስጢር ውይይቶች ሙሉ በሙሉ የተመሰጠሩና ለማንም የማይታዩ ናቸው።'
              : 'Admins can manage platform roles and safety suspensions. However, students’ private health reading history, confidential quiz answers, and counselor inquiries are strictly encrypted and inaccessible.'}
          </p>
        </div>
      </div>

      {/* Filter and Search Bar */}
      <div className="bg-white dark:bg-slate-900 p-4 rounded-2xl border border-slate-200/80 dark:border-slate-800 shadow-xs space-y-3.5">
        <div className="flex flex-col md:flex-row gap-3">
          {/* Search Input */}
          <div className="relative flex-1">
            <Search size={16} className="absolute left-3.5 top-1/2 -translate-y-1/2 text-slate-400 dark:text-slate-500" />
            <input
              type="text"
              value={search}
              onChange={(e) => {
                setSearch(e.target.value);
                setCurrentPage(1);
              }}
              placeholder={
                lang === 'am'
                  ? 'በስም ወይም በኢሜይል አድራሻ ፈልግ...'
                  : 'Search by student name or email address...'
              }
              className="w-full pl-9 pr-8 py-2 text-xs md:text-sm bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl focus:bg-white dark:focus:bg-slate-800/80 focus:border-brand-500 focus:outline-none transition-all text-slate-800 dark:text-slate-100 placeholder:text-slate-400 dark:placeholder:text-slate-500"
            />
            {search && (
              <button
                onClick={() => setSearch('')}
                className="absolute right-2.5 top-1/2 -translate-y-1/2 text-slate-400 hover:text-slate-600 dark:hover:text-slate-200"
              >
                <X size={15} />
              </button>
            )}
          </div>

          {/* Account Status Filter */}
          <div className="flex items-center gap-2">
            <Filter size={15} className="text-slate-400 dark:text-slate-500 flex-shrink-0" />
            <select
              value={statusFilter}
              onChange={(e) => {
                setStatusFilter(e.target.value as any);
                setCurrentPage(1);
              }}
              className="px-3 py-2 text-xs md:text-sm font-semibold rounded-xl border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-800 text-slate-700 dark:text-slate-200 focus:border-brand-500 focus:outline-none"
            >
              <option value="ALL">{lang === 'am' ? 'ሁሉም ሁኔታዎች' : 'All Statuses'}</option>
              <option value="ACTIVE">{lang === 'am' ? 'ነጻ / ንቁ (Active)' : 'Active Accounts'}</option>
              <option value="SUSPENDED">{lang === 'am' ? 'የታገዱ (Suspended)' : 'Suspended Accounts'}</option>
            </select>
          </div>
        </div>

        {/* Role Pills Filter */}
        <div className="flex items-center gap-1.5 overflow-x-auto pb-1 text-xs pt-1 border-t border-slate-100 dark:border-slate-800">
          <span className="text-slate-400 dark:text-slate-500 font-semibold mr-1">{lang === 'am' ? 'ሚና:' : 'Role:'}</span>
          {[
            { id: 'ALL', labelEn: 'All Users', labelAm: 'ሁሉም ተጠቃሚዎች' },
            { id: 'STUDENT', labelEn: 'Students', labelAm: 'ተማሪዎች' },
            { id: 'MENTOR', labelEn: 'Counselors', labelAm: 'አማካሪዎች' },
            { id: 'CONTENT_AUTHOR', labelEn: 'Authors', labelAm: 'ደራሲያን' },
            { id: 'ADMINS', labelEn: 'Admins', labelAm: 'አስተዳዳሪዎች' },
          ].map((r) => (
            <button
              key={r.id}
              onClick={() => {
                setRoleFilter(r.id);
                setCurrentPage(1);
              }}
              className={`px-3 py-1 rounded-lg font-bold transition-colors whitespace-nowrap cursor-pointer ${
                roleFilter === r.id
                  ? 'bg-brand-600 text-white shadow-xs'
                  : 'bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-400 hover:bg-slate-200/70 dark:hover:bg-slate-700'
              }`}
            >
              {lang === 'am' ? r.labelAm : r.labelEn}
            </button>
          ))}
        </div>
      </div>

      {/* Users Table */}
      <div className="bg-white dark:bg-slate-900 rounded-2xl border border-slate-200/80 dark:border-slate-800 shadow-xs overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full text-left text-xs md:text-sm">
            <thead className="bg-slate-50 dark:bg-slate-800/80 border-b border-slate-100 dark:border-slate-800 text-slate-500 dark:text-slate-400 font-bold uppercase text-[11px] tracking-wider">
              <tr>
                <th className="py-3 px-4">{lang === 'am' ? 'ተጠቃሚ' : 'User'}</th>
                <th className="py-3 px-4">{lang === 'am' ? 'የሲስተም ሚና' : 'Platform Role'}</th>
                <th className="py-3 px-4">{lang === 'am' ? 'የተቀላቀሏቸው ክለቦች' : 'Clubs Joined'}</th>
                <th className="py-3 px-4">{lang === 'am' ? 'የአካውንት ሁኔታ' : 'Account Status'}</th>
                <th className="py-3 px-4 text-right">{lang === 'am' ? 'የአመራር እርምጃ' : 'Moderation Actions'}</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-100 dark:divide-slate-800 font-medium">
              {paginatedUsers.map((u) => (
                <tr key={u.id} className="hover:bg-slate-50/70 dark:hover:bg-slate-800/50 transition-colors">
                  <td className="py-3.5 px-4">
                    <div className="flex items-center gap-3">
                      <div className="w-9 h-9 rounded-full bg-slate-100 dark:bg-slate-800 text-brand-700 dark:text-cyan-400 font-extrabold text-xs flex items-center justify-center border border-slate-200 dark:border-slate-700">
                        {u.displayName ? u.displayName.slice(0, 2).toUpperCase() : 'U'}
                      </div>
                      <div>
                        <p className="font-bold text-slate-900 dark:text-white">{u.displayName || 'Anonymous User'}</p>
                        <p className="text-[11px] text-slate-400 dark:text-slate-500">{u.email}</p>
                      </div>
                    </div>
                  </td>
                  <td className="py-3.5 px-4">
                    <select
                      value={u.role}
                      onChange={(e) => onUpdateRole(u.id, e.target.value)}
                      className="px-2.5 py-1 text-xs font-bold rounded-lg border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-800 text-slate-700 dark:text-slate-200 focus:outline-none focus:border-brand-500 cursor-pointer"
                    >
                      <option value="STUDENT">Student (ተማሪ)</option>
                      <option value="MENTOR">Mentor (አማካሪ)</option>
                      <option value="CONTENT_AUTHOR">Content Author</option>
                      <option value="ADMIN">Admin (አስተዳዳሪ)</option>
                      <option value="SUPER_ADMIN">Super Admin</option>
                    </select>
                  </td>
                  <td className="py-3.5 px-4">
                    <span className="inline-flex items-center gap-1 text-xs font-semibold text-slate-600 dark:text-slate-400">
                      <GraduationCap size={13} className="text-slate-400 dark:text-slate-500" />
                      {u.joinedClubCount || 0} clubs
                    </span>
                  </td>
                  <td className="py-3.5 px-4">
                    {u.isSuspended ? (
                      <span className="inline-flex items-center gap-1 text-[11px] font-bold text-rose-700 dark:text-rose-400 bg-rose-50 dark:bg-rose-950/40 px-2.5 py-0.5 rounded-full border border-rose-200 dark:border-rose-800/60">
                        <UserX size={12} />
                        {lang === 'am' ? 'ታግዷል (Suspended)' : 'Suspended'}
                      </span>
                    ) : (
                      <span className="inline-flex items-center gap-1 text-[11px] font-bold text-emerald-700 dark:text-emerald-400 bg-emerald-50 dark:bg-emerald-950/40 px-2.5 py-0.5 rounded-full border border-emerald-200 dark:border-emerald-800/60">
                        <UserCheck size={12} />
                        {lang === 'am' ? 'ነጻ (Active)' : 'Active'}
                      </span>
                    )}
                  </td>
                  <td className="py-3.5 px-4 text-right">
                    <button
                      onClick={() => onToggleSuspension(u.id)}
                      className={`px-3 py-1 rounded-lg text-xs font-bold transition-colors cursor-pointer ${
                        u.isSuspended
                          ? 'bg-emerald-50 dark:bg-emerald-950/40 text-emerald-700 dark:text-emerald-300 hover:bg-emerald-100 dark:hover:bg-emerald-900/50 border border-emerald-200 dark:border-emerald-800'
                          : 'bg-rose-50 dark:bg-rose-950/40 text-rose-700 dark:text-rose-300 hover:bg-rose-100 dark:hover:bg-rose-900/50 border border-rose-200 dark:border-rose-800'
                      }`}
                    >
                      {u.isSuspended
                        ? (lang === 'am' ? 'እገዳ አንሳ' : 'Lift Suspension')
                        : (lang === 'am' ? 'አካውንት አግድ' : 'Suspend Account')}
                    </button>
                  </td>
                </tr>
              ))}
              {filteredUsers.length === 0 && (
                <tr>
                  <td colSpan={5} className="py-12 text-center text-slate-400 dark:text-slate-500">
                    <UsersIcon size={36} className="mx-auto mb-2 opacity-40" />
                    <p className="font-semibold text-sm">
                      {lang === 'am' ? 'ምንም ተጠቃሚ አልተገኘም' : 'No users match your search and filter criteria.'}
                    </p>
                  </td>
                </tr>
              )}
            </tbody>
          </table>
        </div>

        {/* Pagination Bar */}
        {filteredUsers.length > 0 && (
          <div className="px-4 py-3 border-t border-slate-100 dark:border-slate-800 flex flex-col sm:flex-row sm:items-center justify-between gap-3 text-xs text-slate-500 dark:text-slate-400">
            <div className="flex items-center gap-2">
              <span>
                {lang === 'am' ? 'በአንድ ገጽ የሚታዩ:' : 'Rows per page:'}
              </span>
              <select
                value={pageSize}
                onChange={(e) => {
                  setPageSize(Number(e.target.value));
                  setCurrentPage(1);
                }}
                className="px-2 py-0.5 border border-slate-200 dark:border-slate-700 rounded-lg bg-white dark:bg-slate-800 font-semibold text-slate-700 dark:text-slate-200"
              >
                <option value={5}>5</option>
                <option value={10}>10</option>
                <option value={25}>25</option>
                <option value={50}>50</option>
              </select>
              <span className="text-slate-400 dark:text-slate-500">
                {lang === 'am'
                  ? `ከ ${filteredUsers.length} ተጠቃሚዎች ውስጥ ${(safeCurrentPage - 1) * pageSize + 1} - ${Math.min(safeCurrentPage * pageSize, filteredUsers.length)}`
                  : `Showing ${(safeCurrentPage - 1) * pageSize + 1} to ${Math.min(safeCurrentPage * pageSize, filteredUsers.length)} of ${filteredUsers.length} users`}
              </span>
            </div>

            <div className="flex items-center gap-1.5 self-end sm:self-auto">
              <button
                disabled={safeCurrentPage === 1}
                onClick={() => setCurrentPage((p) => Math.max(1, p - 1))}
                className="p-1.5 border border-slate-200 dark:border-slate-700 rounded-lg hover:bg-slate-50 dark:hover:bg-slate-800 disabled:opacity-40 disabled:cursor-not-allowed transition-colors text-slate-600 dark:text-slate-300"
                title="Previous Page"
              >
                <ChevronLeft size={15} />
              </button>
              <span className="px-2 font-bold text-slate-700 dark:text-slate-200">
                {safeCurrentPage} / {totalPages}
              </span>
              <button
                disabled={safeCurrentPage === totalPages}
                onClick={() => setCurrentPage((p) => Math.min(totalPages, p + 1))}
                className="p-1.5 border border-slate-200 dark:border-slate-700 rounded-lg hover:bg-slate-50 dark:hover:bg-slate-800 disabled:opacity-40 disabled:cursor-not-allowed transition-colors text-slate-600 dark:text-slate-300"
                title="Next Page"
              >
                <ChevronRight size={15} />
              </button>
            </div>
          </div>
        )}
      </div>
    </div>
  );
};
