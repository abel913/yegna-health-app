import React, { useEffect, useRef, useState } from 'react';
import L from 'leaflet';
import { Layers, MapPin, Navigation, ExternalLink } from 'lucide-react';

interface CampusMapPickerProps {
  latitude: number;
  longitude: number;
  campusName: string;
  defaultLat?: number;
  defaultLng?: number;
  onChange: (lat: number, lng: number) => void;
  lang?: 'en' | 'am';
}

export const CampusMapPicker: React.FC<CampusMapPickerProps> = ({
  latitude,
  longitude,
  campusName,
  defaultLat,
  defaultLng,
  onChange,
  lang = 'en',
}) => {
  const mapContainerRef = useRef<HTMLDivElement>(null);
  const mapInstanceRef = useRef<L.Map | null>(null);
  const markerRef = useRef<L.Marker | null>(null);
  const tileLayerRef = useRef<L.TileLayer | null>(null);

  const [mapType, setMapType] = useState<'street' | 'satellite'>('street');

  // Custom high-contrast SVG pin (eliminates bundler icon loading bugs)
  const pinIcon = L.divIcon({
    className: 'custom-leaflet-marker',
    html: `
      <div style="
        width: 34px;
        height: 34px;
        display: flex;
        align-items: center;
        justify-content: center;
        background: #0284c7;
        color: white;
        border-radius: 9999px;
        box-shadow: 0 4px 14px rgba(2, 132, 199, 0.45), 0 0 0 3px white;
        transform: translate(-50%, -50%);
        cursor: grab;
      ">
        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
          <path d="M20 10c0 6-8 12-8 12s-8-6-8-12a8 8 0 0 1 16 0Z"></path>
          <circle cx="12" cy="10" r="3"></circle>
        </svg>
      </div>
    `,
    iconSize: [34, 34],
    iconAnchor: [17, 17],
  });

  // Initialize Map
  useEffect(() => {
    if (!mapContainerRef.current) return;

    if (!mapInstanceRef.current) {
      const initialLat = latitude && !isNaN(latitude) ? latitude : 12.6075;
      const initialLng = longitude && !isNaN(longitude) ? longitude : 37.4589;

      const map = L.map(mapContainerRef.current, {
        center: [initialLat, initialLng],
        zoom: 16,
        zoomControl: false,
        attributionControl: false,
      });

      // Custom Zoom Control at bottom right
      L.control.zoom({ position: 'bottomright' }).addTo(map);

      // Tile layer
      const tileUrl =
        mapType === 'street'
          ? 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png'
          : 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}';

      tileLayerRef.current = L.tileLayer(tileUrl, { maxZoom: 19 }).addTo(map);

      // Draggable Marker
      const marker = L.marker([initialLat, initialLng], {
        icon: pinIcon,
        draggable: true,
      }).addTo(map);

      marker.on('dragend', () => {
        const pos = marker.getLatLng();
        onChange(Number(pos.lat.toFixed(6)), Number(pos.lng.toFixed(6)));
      });

      map.on('click', (e: L.LeafletMouseEvent) => {
        marker.setLatLng(e.latlng);
        onChange(Number(e.latlng.lat.toFixed(6)), Number(e.latlng.lng.toFixed(6)));
      });

      markerRef.current = marker;
      mapInstanceRef.current = map;
    }

    return () => {
      // Cleanup on unmount
      if (mapInstanceRef.current) {
        mapInstanceRef.current.remove();
        mapInstanceRef.current = null;
        markerRef.current = null;
        tileLayerRef.current = null;
      }
    };
  }, []);

  // Update marker position when latitude/longitude prop changes externally
  useEffect(() => {
    if (markerRef.current && mapInstanceRef.current) {
      const curr = markerRef.current.getLatLng();
      if (
        Math.abs(curr.lat - latitude) > 0.0001 ||
        Math.abs(curr.lng - longitude) > 0.0001
      ) {
        markerRef.current.setLatLng([latitude, longitude]);
        mapInstanceRef.current.panTo([latitude, longitude], { animate: true });
      }
    }
  }, [latitude, longitude]);

  // Handle Layer Toggle (Street vs Satellite)
  useEffect(() => {
    if (!mapInstanceRef.current || !tileLayerRef.current) return;
    mapInstanceRef.current.removeLayer(tileLayerRef.current);

    const tileUrl =
      mapType === 'street'
        ? 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png'
        : 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}';

    tileLayerRef.current = L.tileLayer(tileUrl, { maxZoom: 19 }).addTo(mapInstanceRef.current);
  }, [mapType]);

  const handleCenterOnCampus = (e: React.MouseEvent) => {
    e.preventDefault();
    e.stopPropagation();
    const targetLat = defaultLat ?? latitude;
    const targetLng = defaultLng ?? longitude;
    if (mapInstanceRef.current && markerRef.current) {
      markerRef.current.setLatLng([targetLat, targetLng]);
      mapInstanceRef.current.setView([targetLat, targetLng], 17, { animate: true });
      onChange(Number(targetLat.toFixed(6)), Number(targetLng.toFixed(6)));
    }
  };

  const googleMapsUrl = `https://www.google.com/maps/search/?api=1&query=${latitude},${longitude}`;

  return (
    <div className="space-y-2">
      <div className="flex items-center justify-between text-xs">
        <label className="font-bold text-slate-700 dark:text-slate-300 flex items-center gap-1.5">
          <MapPin size={14} className="text-brand-600 dark:text-cyan-400" />
          <span>{lang === 'am' ? 'ካርታ ላይ ጠቁም (Pin on Campus Map)' : 'Pin on Campus Map'}</span>
        </label>
        <div className="flex items-center gap-2">
          {defaultLat && defaultLng && (
            <button
              type="button"
              onClick={handleCenterOnCampus}
              className="inline-flex items-center gap-1 text-[11px] font-bold text-brand-600 dark:text-cyan-400 hover:underline cursor-pointer"
            >
              <Navigation size={11} />
              <span>{lang === 'am' ? `ወደ ${campusName || 'ካምፓስ'} መልስ` : `Re-center ${campusName || 'Campus'}`}</span>
            </button>
          )}
          <a
            href={googleMapsUrl}
            target="_blank"
            rel="noopener noreferrer"
            className="inline-flex items-center gap-1 text-[11px] font-medium text-slate-400 hover:text-slate-600 dark:hover:text-slate-200 transition-colors"
          >
            <ExternalLink size={11} />
            <span>Google Maps</span>
          </a>
        </div>
      </div>

      {/* Map Canvas Frame */}
      <div className="relative rounded-2xl overflow-hidden border border-slate-200 dark:border-slate-800 bg-slate-100 dark:bg-slate-900 shadow-inner">
        {/* Top Controls Overlay */}
        <div className="absolute top-2.5 left-2.5 z-40 flex items-center gap-1 bg-white/90 dark:bg-slate-900/90 backdrop-blur-md p-1 rounded-xl border border-slate-200/80 dark:border-slate-800 shadow-xs">
          <button
            type="button"
            onClick={() => setMapType('street')}
            className={`px-2 py-1 rounded-lg text-[10px] font-extrabold transition-all cursor-pointer ${
              mapType === 'street'
                ? 'bg-brand-600 text-white shadow-xs'
                : 'text-slate-600 dark:text-slate-400 hover:bg-slate-100 dark:hover:bg-slate-800'
            }`}
          >
            {lang === 'am' ? 'ካርታ' : 'Map'}
          </button>
          <button
            type="button"
            onClick={() => setMapType('satellite')}
            className={`px-2 py-1 rounded-lg text-[10px] font-extrabold transition-all cursor-pointer ${
              mapType === 'satellite'
                ? 'bg-brand-600 text-white shadow-xs'
                : 'text-slate-600 dark:text-slate-400 hover:bg-slate-100 dark:hover:bg-slate-800'
            }`}
          >
            <span className="flex items-center gap-1">
              <Layers size={11} />
              <span>{lang === 'am' ? 'ሳተላይት' : 'Satellite'}</span>
            </span>
          </button>
        </div>

        {/* Live Coordinate Pill Overlay */}
        <div className="absolute top-2.5 right-2.5 z-40 bg-slate-900/85 text-white backdrop-blur-md px-2.5 py-1 rounded-full text-[10px] font-mono font-bold tracking-tight shadow-md flex items-center gap-1.5 border border-slate-700/60">
          <span className="w-1.5 h-1.5 rounded-full bg-emerald-400 animate-pulse" />
          <span>{latitude.toFixed(5)}°, {longitude.toFixed(5)}°</span>
        </div>

        {/* Leaflet DOM Node */}
        <div ref={mapContainerRef} className="w-full h-52 z-10" />

        {/* Bottom Helper Hint */}
        <div className="absolute bottom-2 left-2 z-40 pointer-events-none bg-white/80 dark:bg-slate-900/80 backdrop-blur-xs px-2 py-0.5 rounded-md text-[10px] text-slate-500 dark:text-slate-400 font-medium border border-slate-200/50 dark:border-slate-800/50">
          {lang === 'am'
            ? 'ካርታው ላይ ጠቅ በማድረግ ወይም ጠቋሚውን በመጎተት ትክክለኛ ቦታ ይምረጡ'
            : 'Click map or drag the pin to set exact building location'}
        </div>
      </div>
    </div>
  );
};
