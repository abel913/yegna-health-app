import React from 'react';
import {
  ShieldAlert,
  UserCheck,
  UserX,
  ShieldCheck,
  GraduationCap,
} from 'lucide-react';
import { ManagedUser } from '../types/index.js';

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
  return (
    <div className="space-y-6">
      {/* Header */}
      <div>
        <h2 className="text-xl md:text-2xl font-extrabold text-slate-900 flex items-center gap-2">
          <ShieldAlert className="text-brand-600" size={24} />
          <span>{lang === 'am' ? 'የተጠቃሚዎች ደህንነትና የአስተዳዳሪ ሚናዎች' : 'User Safety & Role Governance'}</span>
        </h2>
        <p className="text-xs md:text-sm text-slate-500 mt-1">
          {lang === 'am'
            ? 'የተማሪዎችን አካውንት ሚና ያስተዳድሩ፤ የማህበረሰብ ደንቦችን የጣሱ ተጠቃሚዎችን ያግዱ ወይም ይፍቀዱ።'
            : 'Manage user permissions, elevate verified counselors/admins, and suspend abusive accounts.'}
        </p>
      </div>

      {/* Privacy Vault Guarantee Card */}
      <div className="bg-emerald-50 border border-emerald-200/80 rounded-2xl p-4 flex items-start gap-3">
        <ShieldCheck size={22} className="text-emerald-600 flex-shrink-0 mt-0.5" />
        <div>
          <h4 className="text-xs font-bold text-emerald-900">
            {lang === 'am' ? 'የተማሪዎች ሚስጥራዊነት ሕግጋት (Zero-Knowledge Privacy)' : 'Zero-Knowledge Privacy Architecture Active'}
          </h4>
          <p className="text-[11px] text-emerald-700 leading-relaxed mt-0.5">
            {lang === 'am'
              ? 'አስተዳዳሪው የመለያ ሁኔታዎችንና ሚናዎችን ብቻ ማስተዳደር ይችላል። የተማሪዎች የግል የጤና ንባብ፣ የፈተና መልሶች፣ ወይም የምስጢር ውይይቶች ሙሉ በሙሉ የተመሰጠሩና ለማንም የማይታዩ ናቸው።'
              : 'Admins can manage platform roles and safety suspensions. However, students’ private health reading history, confidential quiz answers, and counselor inquiries are strictly encrypted and inaccessible.'}
          </p>
        </div>
      </div>

      {/* Users Table */}
      <div className="bg-white rounded-2xl border border-slate-200/80 shadow-xs overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full text-left text-xs md:text-sm">
            <thead className="bg-slate-50 border-b border-slate-100 text-slate-500 font-bold uppercase text-[11px] tracking-wider">
              <tr>
                <th className="py-3 px-4">User</th>
                <th className="py-3 px-4">Platform Role</th>
                <th className="py-3 px-4">Clubs Joined</th>
                <th className="py-3 px-4">Account Status</th>
                <th className="py-3 px-4 text-right">Moderation Actions</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-100 font-medium">
              {users.map((u) => (
                <tr key={u.id} className="hover:bg-slate-50/70 transition-colors">
                  <td className="py-3.5 px-4">
                    <div className="flex items-center gap-3">
                      <div className="w-9 h-9 rounded-full bg-slate-100 text-slate-700 font-bold text-xs flex items-center justify-center">
                        {u.displayName ? u.displayName.slice(0, 2).toUpperCase() : 'U'}
                      </div>
                      <div>
                        <p className="font-bold text-slate-900">{u.displayName || 'Anonymous User'}</p>
                        <p className="text-[11px] text-slate-400">{u.email}</p>
                      </div>
                    </div>
                  </td>
                  <td className="py-3.5 px-4">
                    <select
                      value={u.role}
                      onChange={(e) => onUpdateRole(u.id, e.target.value)}
                      className="px-2.5 py-1 text-xs font-bold rounded-lg border border-slate-200 bg-white text-slate-700 focus:outline-none focus:border-brand-500"
                    >
                      <option value="STUDENT">Student (ተማሪ)</option>
                      <option value="MENTOR">Mentor (አማካሪ)</option>
                      <option value="CONTENT_AUTHOR">Content Author</option>
                      <option value="ADMIN">Admin (አስተዳዳሪ)</option>
                      <option value="SUPER_ADMIN">Super Admin</option>
                    </select>
                  </td>
                  <td className="py-3.5 px-4">
                    <span className="inline-flex items-center gap-1 text-xs font-semibold text-slate-600">
                      <GraduationCap size={13} className="text-slate-400" />
                      {u.joinedClubCount || 0} clubs
                    </span>
                  </td>
                  <td className="py-3.5 px-4">
                    {u.isSuspended ? (
                      <span className="inline-flex items-center gap-1 text-[11px] font-bold text-rose-700 bg-rose-50 px-2.5 py-0.5 rounded-full border border-rose-200">
                        <UserX size={12} />
                        Suspended (ታግዷል)
                      </span>
                    ) : (
                      <span className="inline-flex items-center gap-1 text-[11px] font-bold text-emerald-700 bg-emerald-50 px-2.5 py-0.5 rounded-full border border-emerald-200">
                        <UserCheck size={12} />
                        Active (ነጻ)
                      </span>
                    )}
                  </td>
                  <td className="py-3.5 px-4 text-right">
                    <button
                      onClick={() => onToggleSuspension(u.id)}
                      className={`px-3 py-1 rounded-lg text-xs font-bold transition-colors ${
                        u.isSuspended
                          ? 'bg-emerald-50 text-emerald-700 hover:bg-emerald-100'
                          : 'bg-rose-50 text-rose-700 hover:bg-rose-100'
                      }`}
                    >
                      {u.isSuspended ? 'Lift Suspension' : 'Suspend Account'}
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
};
