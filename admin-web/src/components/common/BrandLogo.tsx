import React from 'react';

interface BrandLogoProps {
  size?: 'sm' | 'md' | 'lg' | 'xl';
  className?: string;
}

export const BrandLogo: React.FC<BrandLogoProps> = ({ size = 'md', className = '' }) => {
  const sizeMap = {
    sm: 'w-7 h-7 rounded-lg',
    md: 'w-9 h-9 rounded-xl',
    lg: 'w-11 h-11 rounded-xl',
    xl: 'w-14 h-14 rounded-2xl',
  };

  const iconSizeMap = {
    sm: 15,
    md: 19,
    lg: 24,
    xl: 30,
  };

  return (
    <div
      className={`${sizeMap[size]} bg-slate-900 text-white dark:bg-white dark:text-slate-900 border border-slate-800/80 dark:border-slate-200/80 shadow-xs flex items-center justify-center shrink-0 transition-transform ${className}`}
      aria-label="Yegna Health"
    >
      <svg
        width={iconSizeMap[size]}
        height={iconSizeMap[size]}
        viewBox="0 0 24 24"
        fill="none"
        xmlns="http://www.w3.org/2000/svg"
        className="shrink-0"
      >
        {/* Soft rounded medical cross foundation */}
        <rect x="9.25" y="3" width="5.5" height="18" rx="2.75" fill="currentColor" fillOpacity="0.2" />
        <rect x="3" y="9.25" width="18" height="5.5" rx="2.75" fill="currentColor" fillOpacity="0.2" />
        {/* Dynamic vitality pulse rhythm */}
        <path
          d="M3.5 12H6.75L8.75 7.5L12 16.5L14.5 9.5L16.75 12H20.5"
          stroke="currentColor"
          strokeWidth="2.2"
          strokeLinecap="round"
          strokeLinejoin="round"
        />
      </svg>
    </div>
  );
};
