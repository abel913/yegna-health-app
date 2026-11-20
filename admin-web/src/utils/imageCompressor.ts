/**
 * Client-side image compression and Data URI converter.
 * Resizes large photos from smartphones/computers to optimal mobile dimensions
 * and converts them to lightweight Base64 Data URIs stored directly in PostgreSQL.
 */
export async function compressImageFile(
  file: File,
  maxWidth = 800,
  maxHeight = 450,
  quality = 0.82
): Promise<string> {
  return new Promise((resolve, reject) => {
    if (!file.type.startsWith('image/')) {
      reject(new Error('Please upload an image file (PNG, JPG, WebP)'));
      return;
    }

    const reader = new FileReader();
    reader.onload = (readerEvent) => {
      const img = new Image();
      img.onload = () => {
        let { width, height } = img;

        // Calculate proportional scaling
        if (width > maxWidth || height > maxHeight) {
          const ratio = Math.min(maxWidth / width, maxHeight / height);
          width = Math.round(width * ratio);
          height = Math.round(height * ratio);
        }

        const canvas = document.createElement('canvas');
        canvas.width = width;
        canvas.height = height;

        const ctx = canvas.getContext('2d');
        if (!ctx) {
          reject(new Error('Canvas context not available'));
          return;
        }

        // Draw image with smooth bilinear filtering
        ctx.imageSmoothingEnabled = true;
        ctx.imageSmoothingQuality = 'high';
        ctx.drawImage(img, 0, 0, width, height);

        // Convert to optimized JPEG Data URL
        const dataUrl = canvas.toDataURL('image/jpeg', quality);
        resolve(dataUrl);
      };

      img.onerror = () => reject(new Error('Failed to load image file'));
      img.src = readerEvent.target?.result as string;
    };

    reader.onerror = () => reject(new Error('Failed to read file from disk'));
    reader.readAsDataURL(file);
  });
}
