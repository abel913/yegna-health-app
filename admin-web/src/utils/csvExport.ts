/**
 * Professional CSV Export Utility with UTF-8 BOM support for Excel compatibility (supports English & Amharic Geez script).
 */
export function exportToCsv<T>(
  filename: string,
  columns: { header: string; accessor: (item: T) => string | number | boolean | null | undefined }[],
  data: T[]
): void {
  if (!data || data.length === 0) {
    alert('No data available to export.');
    return;
  }

  // 1. Generate Header Row
  const headers = columns.map((c) => escapeCsvCell(c.header)).join(',');

  // 2. Generate Data Rows
  const rows = data.map((item) =>
    columns
      .map((col) => {
        const val = col.accessor(item);
        if (val === null || val === undefined) return '""';
        return escapeCsvCell(String(val));
      })
      .join(',')
  );

  // 3. Assemble CSV Content with UTF-8 BOM (\uFEFF) for Microsoft Excel Amharic support
  const csvContent = '\uFEFF' + [headers, ...rows].join('\r\n');

  // 4. Create Download Blob and trigger anchor click
  const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
  const url = URL.createObjectURL(blob);
  const link = document.createElement('a');
  link.setAttribute('href', url);
  link.setAttribute('download', `${filename}_${new Date().toISOString().slice(0, 10)}.csv`);
  document.body.appendChild(link);
  link.click();
  document.body.removeChild(link);
  URL.revokeObjectURL(url);
}

function escapeCsvCell(cell: string): string {
  // If cell contains commas, quotes, or newlines, wrap in quotes and escape internal quotes
  const needsQuotes = /[",\r\n]/.test(cell);
  const escaped = cell.replace(/"/g, '""');
  return needsQuotes ? `"${escaped}"` : `"${escaped}"`;
}
