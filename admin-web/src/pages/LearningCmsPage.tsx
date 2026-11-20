import React, { useState, useMemo, useEffect } from 'react';
import {
  BookOpen,
  Plus,
  Edit2,
  Trash2,
  Clock,
  X,
  Download,
  Bold,
  Heading2,
  List,
  Quote,
  Search,
  Sparkles,
  Image as ImageIcon,
  Lightbulb,
  Smartphone,
  LayoutTemplate,
  ChevronUp,
  ChevronDown,
  Check,
  HelpCircle,
  FileText,
  Layers,
  ArrowLeft,
  Copy,
  Save,
  ChevronRight,
  Info,
  HeartPulse,
  UploadCloud,
  Link as LinkIcon,
  Play,
  Video,
  ExternalLink,
} from 'lucide-react';
import { Module, QuizQuestion } from '../types/index.js';
import { exportToCsv } from '../utils/csvExport.js';
import { ConfirmModal } from '../components/common/ConfirmModal.js';
import { compressImageFile } from '../utils/imageCompressor.js';
import { EmptyState } from '../components/common/EmptyState.js';
import {
  CURRICULUM_TEMPLATES,
  OFFICIAL_ILLUSTRATIONS,
  CurriculumTemplate,
  CurriculumSection,
  extractYoutubeId,
  parseMarkdownToSections,
  serializeSectionsToMarkdown,
} from '../data/curriculumTemplates.js';
import { ModuleMobilePreview } from '../components/learning/ModuleMobilePreview.js';

interface LearningCmsPageProps {
  modules: Module[];
  lang: 'en' | 'am';
  isLoading?: boolean;
  onSave: (
    data: Partial<Module>,
    id?: string,
    extraQuizzes?: Array<Partial<QuizQuestion>>
  ) => Promise<void>;
  onDelete: (id: string) => Promise<void>;
  questions?: QuizQuestion[];
  onSaveQuestion?: (data: Partial<QuizQuestion>, id?: string) => Promise<void>;
  onDeleteQuestion?: (id: string) => Promise<void>;
}

export const LearningCmsPage: React.FC<LearningCmsPageProps> = ({
  modules,
  lang,
  isLoading = false,
  onSave,
  onDelete,
  questions = [],
}) => {
  const [selectedCategory, setSelectedCategory] = useState('All');
  const [search, setSearch] = useState('');
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingModule, setEditingModule] = useState<Module | null>(null);
  const [moduleToDelete, setModuleToDelete] = useState<Module | null>(null);

  // Studio step navigation: overview, note, sections, quizzes, preview
  const [modalTab, setModalTab] = useState<'overview' | 'note' | 'sections' | 'quizzes' | 'preview'>('overview');
  const [activeLangTab, setActiveLangTab] = useState<'en' | 'am'>('en');
  const [viewMode, setViewMode] = useState<'split' | 'en' | 'am'>('split');
  const [expandedSections, setExpandedSections] = useState<Set<number>>(new Set([0]));

  // Mode for learning sections: visual form cards (easy default) or raw markdown
  const [sectionEditMode, setSectionEditMode] = useState<'form' | 'markdown'>('form');

  const [showTemplatePicker, setShowTemplatePicker] = useState(false);
  const [showImagePicker, setShowImagePicker] = useState(false);
  const [imagePickerTab, setImagePickerTab] = useState<'upload' | 'illustrations' | 'url'>('upload');
  const [isCompressingImage, setIsCompressingImage] = useState(false);
  const [customUrlInput, setCustomUrlInput] = useState('');
  const [isSubmitting, setIsSubmitting] = useState(false);

  // Editing state for an individual quiz question inside Tab 4
  const [editingQuizIndex, setEditingQuizIndex] = useState<number | null>(null);
  const [quizFormOpen, setQuizFormOpen] = useState(false);
  const [quizFormData, setQuizFormData] = useState<{
    id?: string;
    type: 'MULTIPLE_CHOICE' | 'TRUE_FALSE';
    questionEn: string;
    questionAm: string;
    optionsEn: string[];
    optionsAm: string[];
    correctIndex: number;
    explanationEn: string;
    explanationAm: string;
  }>({
    type: 'MULTIPLE_CHOICE',
    questionEn: '',
    questionAm: '',
    optionsEn: ['', '', '', ''],
    optionsAm: ['', '', '', ''],
    correctIndex: 0,
    explanationEn: '',
    explanationAm: '',
  });

  const categories = [
    'All',
    'puberty',
    'srh',
    'sti',
    'hiv',
    'hepatitis',
    'mental_health',
    'gbv',
    'substance',
  ];

  const categoryLabels: Record<string, { en: string; am: string }> = {
    All: { en: 'All Topics', am: 'ሁሉም ዘርፎች' },
    puberty: { en: 'Puberty & Growth', am: 'ጉርምስና' },
    srh: { en: 'Reproductive Health', am: 'ሥነ-ተዋልዶ' },
    sti: { en: 'STI Prevention', am: 'የአባላዘር በሽታዎች' },
    hiv: { en: 'HIV & AIDS Prevention', am: 'ኤች.አይ.ቪ' },
    hepatitis: { en: 'Viral Hepatitis', am: 'የጉበት ቫይረስ' },
    mental_health: { en: 'Mental Health & Stress', am: 'አእምሮ ጤና' },
    gbv: { en: 'GBV & Consent', am: 'ጾታዊ ጥቃት' },
    substance: { en: 'Substance Abuse', am: 'የሱስ መከላከል' },
  };

  // Base module fields
  const [formData, setFormData] = useState({
    category: 'puberty',
    titleEn: '',
    titleAm: '',
    summaryEn: '',
    summaryAm: '',
    doctorNoteEn: '',
    doctorNoteAm: '',
    contentEn: '',
    contentAm: '',
    imageUrl: 'assets/images/learning/module_01_puberty.jpg',
    readTimeMin: 4,
    authorName: 'Dr. Hanna Bekele, Adolescent Specialist',
    isPublished: true,
    orderIndex: 1,
  });

  // Dynamic Visual Sections Form State
  const [sections, setSections] = useState<CurriculumSection[]>([]);

  // Module Quiz Questions State
  const [moduleQuestions, setModuleQuestions] = useState<Array<Partial<QuizQuestion>>>([]);

  // Lock body scroll and capture Escape key when modal is open
  useEffect(() => {
    if (isModalOpen) {
      document.body.style.overflow = 'hidden';
      const handleKeyDown = (e: KeyboardEvent) => {
        if (e.key === 'Escape' && !quizFormOpen && !showImagePicker && !showTemplatePicker) {
          setIsModalOpen(false);
        }
      };
      window.addEventListener('keydown', handleKeyDown);
      return () => {
        document.body.style.overflow = '';
        window.removeEventListener('keydown', handleKeyDown);
      };
    } else {
      document.body.style.overflow = '';
    }
  }, [isModalOpen, quizFormOpen, showImagePicker, showTemplatePicker]);

  // Filter modules by category and full-text search
  const filtered = useMemo(() => {
    return modules.filter((m) => {
      if (selectedCategory !== 'All' && m.category !== selectedCategory) {
        return false;
      }

      if (search.trim()) {
        const query = search.toLowerCase();
        const matchTitle =
          m.titleEn.toLowerCase().includes(query) ||
          m.titleAm.toLowerCase().includes(query);
        const matchSummary =
          m.summaryEn.toLowerCase().includes(query) ||
          m.summaryAm.toLowerCase().includes(query);
        const matchContent =
          m.contentEn.toLowerCase().includes(query) ||
          m.contentAm.toLowerCase().includes(query);
        const matchAuthor = m.authorName?.toLowerCase().includes(query);
        const matchCategory = m.category.toLowerCase().includes(query);

        return (
          matchTitle ||
          matchSummary ||
          matchContent ||
          Boolean(matchAuthor) ||
          matchCategory
        );
      }

      return true;
    });
  }, [modules, selectedCategory, search]);

  const extractNoteFromMarkdown = (content: string): string => {
    const match = content.match(
      /(?:^|\r?\n)(?:[>|]\s*|\s*)(?:Clinical Tip|Medical Note|Doctor(?:\x27s)? Note|የዶክተር ማስታወሻ|ማስታወሻ|Note):\s*([^\n\r]+(?:\r?\n(?!(?:##|#|[>|]|\s*$))[^\n\r]+)*)/i
    );
    return match ? match[1].trim() : '';
  };

  const openCreateModal = () => {
    setEditingModule(null);
    setModalTab('overview');
    setSectionEditMode('form');
    setShowTemplatePicker(false);
    setShowImagePicker(false);
    setQuizFormOpen(false);
    setExpandedSections(new Set([0]));

    const initialSection: CurriculumSection = {
      id: `sec-${Date.now()}-1`,
      titleEn: '1. Introduction',
      titleAm: '1. መግቢያ',
      bodyEn: '',
      bodyAm: '',
      bulletsEn: [''],
      bulletsAm: [''],
      tipEn: '',
      tipAm: '',
      videoUrl: '',
    };

    setFormData({
      category: selectedCategory !== 'All' ? selectedCategory.toLowerCase() : 'srh',
      titleEn: '',
      titleAm: '',
      summaryEn: '',
      summaryAm: '',
      doctorNoteEn: '',
      doctorNoteAm: '',
      contentEn: '',
      contentAm: '',
      imageUrl: '',
      readTimeMin: 4,
      authorName: 'Yegna Health Team',
      isPublished: true,
      orderIndex: modules.length + 1,
    });
    setSections([initialSection]);
    setModuleQuestions([]);
    setIsModalOpen(true);
  };

  const openEditModal = (m: Module) => {
    setEditingModule(m);
    setModalTab('overview');
    setSectionEditMode('form');
    setShowTemplatePicker(false);
    setShowImagePicker(false);
    setQuizFormOpen(false);
    setExpandedSections(new Set([0]));

    const fallbackImg =
      OFFICIAL_ILLUSTRATIONS.find((i) => i.id === m.category)?.path ||
      'assets/images/learning/module_01_puberty.jpg';

    const parsed = parseMarkdownToSections(m.contentEn || '', m.contentAm || '');

    setFormData({
      category: m.category,
      titleEn: m.titleEn,
      titleAm: m.titleAm,
      summaryEn: m.summaryEn,
      summaryAm: m.summaryAm,
      doctorNoteEn:
        m.doctorNoteEn || extractNoteFromMarkdown(m.contentEn || ''),
      doctorNoteAm:
        m.doctorNoteAm || extractNoteFromMarkdown(m.contentAm || ''),
      contentEn: m.contentEn,
      contentAm: m.contentAm,
      imageUrl: m.imageUrl || fallbackImg,
      readTimeMin: m.readTimeMin,
      authorName: m.authorName || '',
      isPublished: m.isPublished,
      orderIndex: m.orderIndex,
    });
    setSections(parsed);

    // Find linked questions for this module from the questions bank
    const linked = questions.filter((q) => q.moduleId === m.id);
    setModuleQuestions(linked.map((q) => ({ ...q })));

    setIsModalOpen(true);
  };

  const applyTemplate = (template: CurriculumTemplate) => {
    const parsed = parseMarkdownToSections(template.contentEn, template.contentAm);
    setFormData((prev) => ({
      ...prev,
      category: template.category,
      titleEn: template.titleEn,
      titleAm: template.titleAm,
      summaryEn: template.summaryEn,
      summaryAm: template.summaryAm,
      doctorNoteEn: template.doctorNoteEn,
      doctorNoteAm: template.doctorNoteAm,
      contentEn: template.contentEn,
      contentAm: template.contentAm,
      imageUrl: template.imageAsset,
      readTimeMin: template.readTimeMin,
      authorName: template.authorName,
    }));
    setSections(parsed);
    setExpandedSections(new Set([0]));

    // If template includes verified quiz questions, load them into the module's questions
    if (template.questions && template.questions.length > 0) {
      setModuleQuestions(
        template.questions.map((q, idx) => ({
          id: `temp-${idx}`,
          type: q.type,
          questionEn: q.questionEn,
          questionAm: q.questionAm,
          optionsEn: q.optionsEn,
          optionsAm: q.optionsAm,
          correctIndex: q.correctIndex,
          explanationEn: q.explanationEn,
          explanationAm: q.explanationAm,
        }))
      );
    }

    setShowTemplatePicker(false);
  };

  // Section Handlers for Form Mode
  const handleAddSection = () => {
    const newIdx = sections.length + 1;
    const newSec: CurriculumSection = {
      id: `sec-${Date.now()}-${Math.random().toString(36).substring(2, 6)}`,
      titleEn: `Section ${newIdx}`,
      titleAm: `ክፍል ${newIdx}`,
      bodyEn: '',
      bodyAm: '',
      bulletsEn: [''],
      bulletsAm: [''],
      tipEn: '',
      tipAm: '',
      videoUrl: '',
    };
    setSections((prev) => [...prev, newSec]);
    setExpandedSections((prev) => new Set([...prev, sections.length]));
  };

  const handleRemoveSection = (index: number) => {
    if (sections.length <= 1) return;
    setSections((prev) => prev.filter((_, i) => i !== index));
    setExpandedSections((prev) => {
      const next = new Set<number>();
      prev.forEach((idx) => {
        if (idx < index) next.add(idx);
        else if (idx > index) next.add(idx - 1);
      });
      return next;
    });
  };

  const handleMoveSection = (index: number, direction: 'up' | 'down') => {
    const targetIndex = direction === 'up' ? index - 1 : index + 1;
    if (targetIndex < 0 || targetIndex >= sections.length) return;

    setSections((prev) => {
      const next = [...prev];
      const temp = next[index];
      next[index] = next[targetIndex];
      next[targetIndex] = temp;
      return next;
    });

    setExpandedSections((prev) => {
      const next = new Set<number>();
      prev.forEach((idx) => {
        if (idx === index) next.add(targetIndex);
        else if (idx === targetIndex) next.add(index);
        else next.add(idx);
      });
      return next;
    });
  };

  const handleUpdateSection = (
    index: number,
    field: keyof CurriculumSection,
    val: any
  ) => {
    setSections((prev) =>
      prev.map((s, i) => (i === index ? { ...s, [field]: val } : s))
    );
  };

  const handleAddBullet = (secIndex: number) => {
    setSections((prev) =>
      prev.map((s, i) => {
        if (i !== secIndex) return s;
        return {
          ...s,
          bulletsEn: [...s.bulletsEn, ''],
          bulletsAm: [...s.bulletsAm, ''],
        };
      })
    );
  };

  const handleRemoveBullet = (secIndex: number, bulletIndex: number) => {
    setSections((prev) =>
      prev.map((s, i) => {
        if (i !== secIndex) return s;
        return {
          ...s,
          bulletsEn: s.bulletsEn.filter((_, bIdx) => bIdx !== bulletIndex),
          bulletsAm: s.bulletsAm.filter((_, bIdx) => bIdx !== bulletIndex),
        };
      })
    );
  };

  const handleUpdateBullet = (
    secIndex: number,
    bulletIndex: number,
    bulletLang: 'en' | 'am',
    val: string
  ) => {
    setSections((prev) =>
      prev.map((s, i) => {
        if (i !== secIndex) return s;
        if (bulletLang === 'en') {
          const newBullets = [...s.bulletsEn];
          newBullets[bulletIndex] = val;
          return { ...s, bulletsEn: newBullets };
        } else {
          const newBullets = [...s.bulletsAm];
          newBullets[bulletIndex] = val;
          return { ...s, bulletsAm: newBullets };
        }
      })
    );
  };

  // Accordion Expand/Collapse Helpers
  const toggleSectionExpanded = (idx: number) => {
    setExpandedSections((prev) => {
      const next = new Set(prev);
      if (next.has(idx)) {
        next.delete(idx);
      } else {
        next.add(idx);
      }
      return next;
    });
  };

  const expandAllSections = () => {
    setExpandedSections(new Set(sections.map((_, i) => i)));
  };

  const collapseAllSections = () => {
    setExpandedSections(new Set());
  };

  // 1-Click Interactive Correct Answer Selector for Quiz Cards
  const handleSetCorrectAnswer = (qIdx: number, oIdx: number) => {
    setModuleQuestions((prev) => {
      const next = [...prev];
      next[qIdx] = { ...next[qIdx], correctIndex: oIdx };
      return next;
    });
  };

  // Sync between Form Mode and Markdown Mode
  const handleToggleSectionMode = (newMode: 'form' | 'markdown') => {
    if (newMode === 'markdown') {
      const serialized = serializeSectionsToMarkdown(sections);
      setFormData((prev) => ({
        ...prev,
        contentEn: serialized.contentEn,
        contentAm: serialized.contentAm,
      }));
    } else {
      const parsed = parseMarkdownToSections(formData.contentEn, formData.contentAm);
      setSections(parsed);
      setExpandedSections(new Set([0]));
    }
    setSectionEditMode(newMode);
  };

  // 1-Click Bilingual Mirroring for Sections
  const handleMirrorToAmharic = () => {
    setFormData((prev) => ({
      ...prev,
      titleAm: prev.titleAm.trim() ? prev.titleAm : prev.titleEn,
      summaryAm: prev.summaryAm.trim() ? prev.summaryAm : prev.summaryEn,
      doctorNoteAm: prev.doctorNoteAm.trim() ? prev.doctorNoteAm : prev.doctorNoteEn,
    }));

    setSections((prev) =>
      prev.map((sec, idx) => {
        const mirroredTitle =
          sec.titleAm.trim() && sec.titleAm !== `ክፍል ${idx + 1}`
            ? sec.titleAm
            : sec.titleEn || `ክፍል ${idx + 1}`;
        const mirroredBody = sec.bodyAm.trim() ? sec.bodyAm : sec.bodyEn;
        const mirroredTip = sec.tipAm?.trim() ? sec.tipAm : (sec.tipEn || '');
        const mirroredBullets = sec.bulletsEn.map((bEn, bIdx) => {
          const existing = sec.bulletsAm[bIdx];
          return existing && existing.trim() ? existing : bEn;
        });

        return {
          ...sec,
          titleAm: mirroredTitle,
          bodyAm: mirroredBody,
          bulletsAm: mirroredBullets.length > 0 ? mirroredBullets : [''],
          tipAm: mirroredTip,
        };
      })
    );
  };

  // Auto-calculate reading time based on total word count (~180 wpm)
  const calculateReadingTime = () => {
    let wordCount = 0;
    if (sectionEditMode === 'form') {
      sections.forEach((s) => {
        wordCount += `${s.titleEn} ${s.bodyEn} ${s.bulletsEn.join(' ')} ${s.tipEn || ''}`
          .trim()
          .split(/\s+/)
          .filter(Boolean).length;
      });
    } else {
      wordCount += (formData.contentEn || '').trim().split(/\s+/).filter(Boolean).length;
    }
    wordCount += (formData.summaryEn || '').trim().split(/\s+/).filter(Boolean).length;
    wordCount += (formData.doctorNoteEn || '').trim().split(/\s+/).filter(Boolean).length;
    const mins = Math.max(1, Math.round(wordCount / 180));
    setFormData((prev) => ({ ...prev, readTimeMin: mins }));
  };

  // Image Upload and URL Handlers
  const handleImageFileUpload = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;
    try {
      setIsCompressingImage(true);
      const dataUri = await compressImageFile(file, 800, 450, 0.8);
      setFormData((prev) => ({ ...prev, imageUrl: dataUri }));
      setShowImagePicker(false);
    } catch (err) {
      console.error('Image compression failed:', err);
      alert(
        lang === 'am'
          ? 'የስዕሉ ማስተካከል አልተሳካም። እባክዎ እንደገና ይሞክሩ።'
          : 'Failed to process image. Please try a different image.'
      );
    } finally {
      setIsCompressingImage(false);
      e.target.value = '';
    }
  };

  const handleApplyCustomUrl = () => {
    if (!customUrlInput.trim()) return;
    setFormData((prev) => ({ ...prev, imageUrl: customUrlInput.trim() }));
    setCustomUrlInput('');
    setShowImagePicker(false);
  };

  // Quiz Question Handlers inside Module Editor
  const openAddQuizQuestion = (type: 'MULTIPLE_CHOICE' | 'TRUE_FALSE' = 'MULTIPLE_CHOICE') => {
    setEditingQuizIndex(null);
    const isTf = type === 'TRUE_FALSE';
    setQuizFormData({
      type,
      questionEn: '',
      questionAm: '',
      optionsEn: isTf ? ['True', 'False'] : ['', '', '', ''],
      optionsAm: isTf ? ['እውነት', 'ሐሰት'] : ['', '', '', ''],
      correctIndex: 0,
      explanationEn: '',
      explanationAm: '',
    });
    setQuizFormOpen(true);
  };

  const openEditQuizQuestion = (q: Partial<QuizQuestion>, idx: number) => {
    setEditingQuizIndex(idx);
    const isTf = q.type === 'TRUE_FALSE';
    setQuizFormData({
      id: q.id,
      type: q.type || 'MULTIPLE_CHOICE',
      questionEn: q.questionEn || '',
      questionAm: q.questionAm || '',
      optionsEn:
        q.optionsEn && q.optionsEn.length > 0
          ? [...q.optionsEn]
          : isTf
          ? ['True', 'False']
          : ['', '', '', ''],
      optionsAm:
        q.optionsAm && q.optionsAm.length > 0
          ? [...q.optionsAm]
          : isTf
          ? ['እውነት', 'ሐሰት']
          : ['', '', '', ''],
      correctIndex: q.correctIndex ?? 0,
      explanationEn: q.explanationEn || '',
      explanationAm: q.explanationAm || '',
    });
    setQuizFormOpen(true);
  };

  const handleSaveQuizQuestion = (e: React.FormEvent) => {
    e.preventDefault();
    if (!quizFormData.questionEn.trim() && !quizFormData.questionAm.trim()) {
      return;
    }

    const newQuestion: Partial<QuizQuestion> = {
      ...quizFormData,
      id: quizFormData.id || `temp-${Date.now()}`,
    };

    if (editingQuizIndex !== null) {
      setModuleQuestions((prev) =>
        prev.map((q, i) => (i === editingQuizIndex ? newQuestion : q))
      );
    } else {
      setModuleQuestions((prev) => [...prev, newQuestion]);
    }

    setQuizFormOpen(false);
    setEditingQuizIndex(null);
  };

  const handleDeleteQuizQuestion = (idx: number) => {
    setModuleQuestions((prev) => prev.filter((_, i) => i !== idx));
    if (editingQuizIndex === idx) {
      setQuizFormOpen(false);
      setEditingQuizIndex(null);
    }
  };

  const handleDuplicateQuizQuestion = (idx: number) => {
    const source = moduleQuestions[idx];
    if (!source) return;
    const duplicate: Partial<QuizQuestion> = {
      ...source,
      id: `temp-${Date.now()}`,
      questionEn: `${source.questionEn || ''} (Copy)`,
      questionAm: source.questionAm ? `${source.questionAm} (ቅጂ)` : '',
    };
    setModuleQuestions((prev) => [...prev.slice(0, idx + 1), duplicate, ...prev.slice(idx + 1)]);
  };

  // Fast Markdown Syntax Helper
  const insertMarkdown = (syntaxPrefix: string, syntaxSuffix: string = '') => {
    if (activeLangTab === 'en') {
      setFormData((prev) => ({
        ...prev,
        contentEn: `${prev.contentEn}\n${syntaxPrefix}Sample Text${syntaxSuffix}`,
      }));
    } else {
      setFormData((prev) => ({
        ...prev,
        contentAm: `${prev.contentAm}\n${syntaxPrefix}ምሳሌ ጽሑፍ${syntaxSuffix}`,
      }));
    }
  };

  const handleSubmit = async (e?: React.FormEvent) => {
    if (e) e.preventDefault();
    if (isSubmitting) return;

    const rawTitleEn = formData.titleEn.trim();
    const rawTitleAm = formData.titleAm.trim();
    if (!rawTitleEn && !rawTitleAm) {
      alert(lang === 'am' ? 'እባክዎ የሞጁሉን ርዕስ ያስገቡ' : 'Please enter a module title');
      return;
    }
    const finalTitleEn = rawTitleEn || rawTitleAm;
    const finalTitleAm = rawTitleAm || rawTitleEn;

    let rawSummaryEn = formData.summaryEn.trim();
    let rawSummaryAm = formData.summaryAm.trim();
    if (!rawSummaryEn && !rawSummaryAm) {
      alert(lang === 'am' ? 'እባክዎ ማጠቃለያ ያስገቡ' : 'Please enter a module summary');
      return;
    }
    let finalSummaryEn = rawSummaryEn || rawSummaryAm;
    let finalSummaryAm = rawSummaryAm || rawSummaryEn;
    if (finalSummaryEn.length < 5) finalSummaryEn = finalSummaryEn.padEnd(5, '.');
    if (finalSummaryAm.length < 5) finalSummaryAm = finalSummaryAm.padEnd(5, '.');

    try {
      setIsSubmitting(true);

      let finalContentEn = formData.contentEn;
      let finalContentAm = formData.contentAm;

      if (sectionEditMode === 'form') {
        const serialized = serializeSectionsToMarkdown(sections);
        finalContentEn = formData.doctorNoteEn.trim()
          ? `| Note: ${formData.doctorNoteEn.trim()}\n\n${serialized.contentEn}`
          : serialized.contentEn;
        finalContentAm = formData.doctorNoteAm.trim()
          ? `| ማስታወሻ: ${formData.doctorNoteAm.trim()}\n\n${serialized.contentAm}`
          : serialized.contentAm;
      } else {
        if (
          formData.doctorNoteEn.trim() &&
          !finalContentEn.trim().startsWith('| Note')
        ) {
          finalContentEn = `| Note: ${formData.doctorNoteEn.trim()}\n\n${finalContentEn}`;
        }
        if (
          formData.doctorNoteAm.trim() &&
          !finalContentAm.trim().startsWith('| ማስታወሻ')
        ) {
          finalContentAm = `| ማስታወሻ: ${formData.doctorNoteAm.trim()}\n\n${finalContentAm}`;
        }
      }

      finalContentEn = finalContentEn.trim();
      finalContentAm = finalContentAm.trim();
      if (!finalContentEn && finalContentAm) finalContentEn = finalContentAm;
      if (!finalContentAm && finalContentEn) finalContentAm = finalContentEn;
      if (finalContentEn.length < 10) {
        finalContentEn = `${finalContentEn}\n\nClinical guidelines and practical resources for students.`;
      }
      if (finalContentAm.length < 10) {
        finalContentAm = `${finalContentAm}\n\nለተማሪዎች ጠቃሚ የጤና መመሪያ እና ምክሮች።`;
      }

      const finalPayload: Partial<Module> = {
        ...formData,
        titleEn: finalTitleEn,
        titleAm: finalTitleAm,
        summaryEn: finalSummaryEn,
        summaryAm: finalSummaryAm,
        contentEn: finalContentEn,
        contentAm: finalContentAm,
      };

      await onSave(
        finalPayload,
        editingModule ? editingModule.id : undefined,
        moduleQuestions
      );

      setIsModalOpen(false);
    } finally {
      setIsSubmitting(false);
    }
  };

  const currentThumbnailUrl = useMemo(() => {
    if (!formData.imageUrl) return '/illustrations/module_01_puberty.jpg';
    if (
      formData.imageUrl.startsWith('http://') ||
      formData.imageUrl.startsWith('https://') ||
      formData.imageUrl.startsWith('data:image')
    ) {
      return formData.imageUrl;
    }
    const clean = formData.imageUrl.replace(/^assets\/images\/learning\//, '');
    return `/illustrations/${clean}`;
  }, [formData.imageUrl]);

  return (
    <div className="space-y-6">
      {/* Top Banner and Quick Actions */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 bg-white dark:bg-slate-900 p-5 rounded-2xl border border-slate-200/80 dark:border-slate-800 shadow-2xs">
        <div>
          <h2 className="text-xl font-extrabold text-slate-900 dark:text-white flex items-center gap-2">
            <BookOpen className="text-slate-900 dark:text-white" size={22} />
            <span>{lang === 'am' ? 'የትምህርት ሞጁሎች ማኔጅመንት' : 'Health Curriculum CMS'}</span>
          </h2>
          <p className="text-xs text-slate-500 dark:text-slate-400 mt-1">
            {lang === 'am'
              ? 'ክሊኒካዊ ትምህርቶችን፣ የዶክተር ማስታወሻዎችን፣ አኮርዲዮን ክፍሎችንና የፈተና ጥያቄዎችን ያቀናብሩ'
              : 'Enterprise curriculum studio for clinical lessons, doctor takeaway notes, and knowledge quizzes'}
          </p>
        </div>

        <div className="flex items-center gap-2">
          <button
            onClick={() => {
              exportToCsv(
                'yegna-health-curriculum',
                [
                  { header: 'ID', accessor: (m) => m.id },
                  { header: 'Category', accessor: (m) => m.category },
                  { header: 'Title (EN)', accessor: (m) => m.titleEn },
                  { header: 'Title (AM)', accessor: (m) => m.titleAm },
                  { header: 'Read Time (min)', accessor: (m) => m.readTimeMin },
                  { header: 'Author', accessor: (m) => m.authorName || '' },
                  { header: 'Published', accessor: (m) => (m.isPublished ? 'Yes' : 'No') },
                  { header: 'Sections Count', accessor: (m) => (m.contentEn ? m.contentEn.split('##').length - 1 : 0) },
                ],
                modules
              );
            }}
            className="px-3 py-2 border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-800 hover:bg-slate-50 dark:hover:bg-slate-700 text-slate-700 dark:text-slate-200 rounded-xl text-xs font-bold transition-all shadow-2xs flex items-center gap-1.5 cursor-pointer"
          >
            <Download size={14} />
            <span className="hidden sm:inline">{lang === 'am' ? 'ዳታ አውርድ' : 'Export CSV'}</span>
          </button>

          <button
            onClick={openCreateModal}
            className="px-4 py-2 bg-slate-950 hover:bg-slate-800 dark:bg-white dark:hover:bg-slate-100 text-white dark:text-slate-950 rounded-xl text-xs font-extrabold transition-all border border-slate-900 dark:border-white shadow-xs flex items-center gap-1.5 active:scale-[0.99] cursor-pointer"
          >
            <Plus size={15} />
            <span>{lang === 'am' ? 'አዲስ ሞጁል አዘጋጅ' : 'Create Health Module'}</span>
          </button>
        </div>
      </div>

      {/* Filter and Search Bar */}
      <div className="flex flex-col md:flex-row gap-3 items-stretch md:items-center justify-between">
        <div className="flex items-center gap-1.5 overflow-x-auto pb-1 max-w-full">
          {categories.map((cat) => {
            const isSel = selectedCategory === cat;
            const label =
              lang === 'am'
                ? categoryLabels[cat]?.am || cat
                : categoryLabels[cat]?.en || cat;
            return (
              <button
                key={cat}
                onClick={() => setSelectedCategory(cat)}
                className={`px-3 py-1.5 rounded-xl text-xs font-bold transition-all whitespace-nowrap cursor-pointer ${
                  isSel
                    ? 'bg-slate-950 dark:bg-white text-white dark:text-slate-950 shadow-xs'
                    : 'bg-white dark:bg-slate-900 border border-slate-200/80 dark:border-slate-800 text-slate-600 dark:text-slate-400 hover:border-slate-300'
                }`}
              >
                {label}
              </button>
            );
          })}
        </div>

        <div className="relative min-w-[240px]">
          <Search
            size={14}
            className="absolute left-3 top-1/2 -translate-y-1/2 text-slate-400"
          />
          <input
            type="text"
            placeholder={
              lang === 'am'
                ? 'በርዕስ፣ በይዘት ወይም በደራሲ ፈልግ...'
                : 'Search curriculum titles, summaries, or authors...'
            }
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            className="w-full pl-9 pr-3 py-1.5 bg-white dark:bg-slate-900 border border-slate-200/80 dark:border-slate-800 rounded-xl text-xs text-slate-900 dark:text-white placeholder:text-slate-400 focus:outline-hidden focus:border-slate-900 dark:focus:border-white transition-all"
          />
        </div>
      </div>

      {/* Modules Catalog Grid, Skeleton, or Empty State */}
      {isLoading && modules.length === 0 ? (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
          {Array.from({ length: 6 }).map((_, idx) => (
            <div
              key={idx}
              className="bg-white dark:bg-slate-900 rounded-2xl border border-slate-200/80 dark:border-slate-800 p-5 shadow-2xs animate-pulse space-y-3"
            >
              <div className="flex items-center justify-between">
                <div className="h-5 bg-slate-200 dark:bg-slate-800 rounded w-20" />
                <div className="h-4 bg-slate-100 dark:bg-slate-800/60 rounded w-16" />
              </div>
              <div className="h-32 bg-slate-100 dark:bg-slate-800/60 rounded-xl w-full" />
              <div className="h-5 bg-slate-200 dark:bg-slate-800 rounded w-3/4" />
              <div className="h-3 bg-slate-100 dark:bg-slate-800/60 rounded w-1/2" />
            </div>
          ))}
        </div>
      ) : filtered.length === 0 ? (
        <EmptyState
          title={lang === 'am' ? 'ምንም የትምህርት ሞጁል አልተገኘም' : 'No curriculum modules found'}
          description={
            lang === 'am'
              ? 'የተመረጠውን ዘርፍ ወይም የፍለጋ ቃል በመቀየር እንደገና ይሞክሩ።'
              : 'Try selecting another topic filter or create a new curriculum module.'
          }
          actionLabel={lang === 'am' ? 'አዲስ ሞጁል ፍጠር' : 'Create Health Module'}
          onAction={openCreateModal}
        />
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
          {filtered.map((m) => {
            const fallbackImg =
              OFFICIAL_ILLUSTRATIONS.find((i) => i.id === m.category)?.previewUrl ||
              '/illustrations/module_01_puberty.jpg';
            const cardImgUrl = m.imageUrl
              ? (m.imageUrl.startsWith('http') || m.imageUrl.startsWith('data:image'))
                ? m.imageUrl
                : `/illustrations/${m.imageUrl.replace(/^assets\/images\/learning\//, '')}`
              : fallbackImg;

            const linkedQuizCount = questions.filter((q) => q.moduleId === m.id).length;

            return (
              <div
                key={m.id}
                className="bg-white dark:bg-slate-900 rounded-2xl border border-slate-200/80 dark:border-slate-800 p-5 shadow-2xs hover:shadow-md transition-all flex flex-col justify-between group"
              >
                <div>
                  <div className="flex items-center justify-between mb-3">
                    <span className="px-2.5 py-0.5 rounded-full text-[10px] font-extrabold uppercase bg-slate-100 dark:bg-slate-800 text-slate-800 dark:text-slate-200 border border-slate-200 dark:border-slate-700">
                      {m.category}
                    </span>

                    <div className="flex items-center gap-1 opacity-80 group-hover:opacity-100 transition-opacity">
                      <button
                        onClick={() => openEditModal(m)}
                        className="p-1.5 text-slate-400 hover:text-slate-900 dark:hover:text-white hover:bg-slate-50 dark:hover:bg-slate-800 rounded-lg cursor-pointer"
                        title={lang === 'am' ? 'አርትዕ' : 'Edit Module'}
                      >
                        <Edit2 size={14} />
                      </button>
                      <button
                        onClick={() => setModuleToDelete(m)}
                        className="p-1.5 text-slate-400 hover:text-rose-600 dark:hover:text-rose-400 hover:bg-rose-50 dark:hover:bg-rose-950/30 rounded-lg cursor-pointer"
                        title={lang === 'am' ? 'ሰርዝ' : 'Delete Module'}
                      >
                        <Trash2 size={14} />
                      </button>
                    </div>
                  </div>

                  <div className="flex items-start gap-3.5 mb-3">
                    <div className="w-16 h-16 rounded-xl bg-slate-50 dark:bg-slate-800 border border-slate-100 dark:border-slate-700/60 overflow-hidden shrink-0 flex items-center justify-center p-1">
                      <img
                        src={cardImgUrl}
                        alt=""
                        className="w-full h-full object-contain"
                        onError={(e) => {
                          (e.target as HTMLImageElement).src =
                            '/illustrations/module_01_puberty.jpg';
                        }}
                      />
                    </div>
                    <div className="min-w-0 flex-1">
                      <h3 className="font-extrabold text-slate-900 dark:text-white text-base leading-tight mb-1">
                        {lang === 'am' ? m.titleAm : m.titleEn}
                      </h3>
                      <p className="text-xs text-slate-400 dark:text-slate-500 truncate mb-1">
                        {lang === 'am' ? m.titleEn : m.titleAm}
                      </p>
                    </div>
                  </div>

                  <p className="text-xs text-slate-600 dark:text-slate-300 line-clamp-2 leading-relaxed">
                    {lang === 'am' ? m.summaryAm : m.summaryEn}
                  </p>
                </div>

                <div className="pt-4 mt-4 border-t border-slate-100 dark:border-slate-800 flex items-center justify-between text-xs text-slate-400 dark:text-slate-500">
                  <span className="flex items-center gap-1 font-semibold text-slate-600 dark:text-slate-300">
                    <Clock size={13} className="text-slate-400 dark:text-slate-500" />
                    {m.readTimeMin} min read
                  </span>
                  <span className="text-[11px] font-semibold text-slate-800 dark:text-slate-200 bg-slate-100 dark:bg-slate-800 px-2 py-0.5 rounded-full border border-slate-200 dark:border-slate-700">
                    {linkedQuizCount} {lang === 'am' ? 'ፈተናዎች' : 'Quizzes'}
                  </span>
                </div>
              </div>
            );
          })}
        </div>
      )}

      {/* ========================================================================= */}
      {/* ENTERPRISE-GRADE CURRICULUM STUDIO WORKSPACE                              */}
      {/* ========================================================================= */}
      {isModalOpen && (
        <div className="fixed inset-0 z-50 bg-slate-100/90 dark:bg-slate-950 flex flex-col overflow-hidden animate-in fade-in duration-150 font-['Plus_Jakarta_Sans',sans-serif]">
          {/* STUDIO TOP NAVIGATION BAR */}
          <header className="px-5 sm:px-8 py-3.5 bg-white dark:bg-slate-900 border-b border-slate-200 dark:border-slate-800 flex items-center justify-between shrink-0 shadow-xs z-30">
            <div className="flex items-center gap-3 min-w-0">
              <button
                type="button"
                onClick={() => setIsModalOpen(false)}
                className="flex items-center gap-1.5 px-3 py-1.5 rounded-xl border border-slate-200 dark:border-slate-700 bg-slate-50 dark:bg-slate-800 text-slate-600 dark:text-slate-300 hover:text-slate-900 dark:hover:text-white hover:bg-slate-100 dark:hover:bg-slate-700 text-xs font-bold transition-all cursor-pointer"
              >
                <ArrowLeft size={14} />
                <span>{lang === 'am' ? 'ተመለስ' : 'Curriculum'}</span>
              </button>
              <div className="h-4 w-px bg-slate-200 dark:bg-slate-700" />
              <div className="min-w-0">
                <div className="flex items-center gap-2">
                  <h3 className="font-extrabold text-sm sm:text-base text-slate-900 dark:text-white truncate max-w-sm">
                    {formData.titleEn || (lang === 'am' ? 'አዲስ የትምህርት ሞጁል' : 'Untitled Health Curriculum')}
                  </h3>
                  <span className="px-2 py-0.5 rounded-full text-[10px] font-extrabold uppercase bg-slate-100 dark:bg-slate-800 text-slate-800 dark:text-slate-200 border border-slate-200 dark:border-slate-700 shrink-0">
                    {formData.category}
                  </span>
                </div>
                <p className="text-[11px] text-slate-400 truncate">
                  {sections.length} {lang === 'am' ? 'ክፍሎች' : 'Sections'} • {moduleQuestions.length} {lang === 'am' ? 'ፈተናዎች' : 'Quizzes'} • {formData.readTimeMin} min read
                </p>
              </div>
            </div>

            {/* Central Segmented Step Navigation Tabs */}
            <div className="hidden lg:flex items-center gap-1 bg-slate-100 dark:bg-slate-800/80 p-1 rounded-2xl border border-slate-200/70 dark:border-slate-700">
              {[
                { id: 'overview', icon: FileText, label: lang === 'am' ? '1. አጠቃላይ' : '1. Overview' },
                { id: 'note', icon: Lightbulb, label: lang === 'am' ? '2. ማስታወሻ' : '2. Doctor Note' },
                { id: 'sections', icon: Layers, label: lang === 'am' ? `3. ክፍሎች (${sections.length})` : `3. Sections (${sections.length})` },
                { id: 'quizzes', icon: HelpCircle, label: lang === 'am' ? `4. ፈተና (${moduleQuestions.length})` : `4. Quiz (${moduleQuestions.length})` },
                { id: 'preview', icon: Smartphone, label: lang === 'am' ? '5. የሞባይል እይታ' : '5. Phone Preview' },
              ].map((tab) => {
                const Icon = tab.icon;
                const isActive = modalTab === tab.id;
                return (
                  <button
                    key={tab.id}
                    type="button"
                    onClick={() => setModalTab(tab.id as any)}
                    className={`flex items-center gap-1.5 px-3 py-1.5 rounded-xl text-xs font-bold transition-all cursor-pointer ${
                      isActive
                        ? 'bg-white dark:bg-slate-700 text-slate-900 dark:text-white shadow-xs'
                        : 'text-slate-500 hover:text-slate-900 dark:hover:text-white'
                    }`}
                  >
                    <Icon size={13} />
                    <span>{tab.label}</span>
                  </button>
                );
              })}
            </div>

            {/* Right Language Mode Switcher & Primary Save Action */}
            <div className="flex items-center gap-2">
              <div className="flex items-center bg-slate-100 dark:bg-slate-800 p-0.5 rounded-xl border border-slate-200 dark:border-slate-700 text-xs font-bold">
                <button
                  type="button"
                  onClick={() => setViewMode('split')}
                  className={`px-2.5 py-1 rounded-lg transition-all cursor-pointer ${
                    viewMode === 'split'
                      ? 'bg-white dark:bg-slate-700 text-slate-900 dark:text-white shadow-xs'
                      : 'text-slate-500 hover:text-slate-800 dark:hover:text-white'
                  }`}
                  title="Side-by-side bilingual view"
                >
                  Split
                </button>
                <button
                  type="button"
                  onClick={() => setViewMode('en')}
                  className={`px-2.5 py-1 rounded-lg transition-all cursor-pointer ${
                    viewMode === 'en'
                      ? 'bg-white dark:bg-slate-700 text-slate-900 dark:text-white shadow-xs'
                      : 'text-slate-500 hover:text-slate-800 dark:hover:text-white'
                  }`}
                  title="English only view"
                >
                  EN
                </button>
                <button
                  type="button"
                  onClick={() => setViewMode('am')}
                  className={`px-2.5 py-1 rounded-lg transition-all cursor-pointer ${
                    viewMode === 'am'
                      ? 'bg-white dark:bg-slate-700 text-slate-900 dark:text-white shadow-xs'
                      : 'text-slate-500 hover:text-slate-800 dark:hover:text-white'
                  }`}
                  title="Amharic only view"
                >
                  አማ
                </button>
              </div>

              <button
                type="button"
                onClick={() => handleSubmit()}
                disabled={isSubmitting || !formData.titleEn.trim()}
                className="px-4 py-2 bg-slate-950 hover:bg-slate-800 dark:bg-white dark:hover:bg-slate-100 text-white dark:text-slate-950 rounded-xl text-xs font-extrabold transition-all border border-slate-900 dark:border-white shadow-xs flex items-center gap-1.5 cursor-pointer disabled:opacity-50 active:scale-[0.99]"
              >
                {isSubmitting ? (
                  <>
                    <div className="w-3.5 h-3.5 border-2 border-white border-t-transparent rounded-full animate-spin" />
                    <span>{lang === 'am' ? 'በመመዝገብ ላይ...' : 'Saving...'}</span>
                  </>
                ) : (
                  <>
                    <Save size={14} />
                    <span>{lang === 'am' ? 'ለውጦችን መዝግብ' : 'Save & Publish'}</span>
                  </>
                )}
              </button>
            </div>
          </header>

          {/* Subnav for Tablet/Mobile screen width */}
          <div className="lg:hidden flex items-center gap-1 px-4 py-2 bg-slate-100 dark:bg-slate-850 border-b border-slate-200 dark:border-slate-800 overflow-x-auto shrink-0">
            {[
              { id: 'overview', icon: FileText, label: lang === 'am' ? '1. አጠቃላይ' : '1. Overview' },
              { id: 'note', icon: Lightbulb, label: lang === 'am' ? '2. ማስታወሻ' : '2. Doctor Note' },
              { id: 'sections', icon: Layers, label: lang === 'am' ? `3. ክፍሎች (${sections.length})` : `3. Sections (${sections.length})` },
              { id: 'quizzes', icon: HelpCircle, label: lang === 'am' ? `4. ፈተና (${moduleQuestions.length})` : `4. Quiz (${moduleQuestions.length})` },
              { id: 'preview', icon: Smartphone, label: lang === 'am' ? '5. እይታ' : '5. Phone Preview' },
            ].map((tab) => {
              const Icon = tab.icon;
              const isActive = modalTab === tab.id;
              return (
                <button
                  key={tab.id}
                  type="button"
                  onClick={() => setModalTab(tab.id as any)}
                  className={`flex items-center gap-1.5 px-3 py-1.5 rounded-xl text-xs font-bold whitespace-nowrap cursor-pointer ${
                    isActive
                      ? 'bg-white dark:bg-slate-700 text-slate-900 dark:text-white shadow-xs'
                      : 'text-slate-500 hover:text-slate-900'
                  }`}
                >
                  <Icon size={12} />
                  <span>{tab.label}</span>
                </button>
              );
            })}
          </div>

          {/* MAIN SCROLLABLE STUDIO CANVAS */}
          <main className="flex-1 overflow-y-auto p-4 sm:p-8 bg-slate-50/70 dark:bg-slate-950">
            <div className="max-w-5xl mx-auto space-y-6">

              {/* ========================================================================= */}
              {/* TAB 1: OVERVIEW & COVER STUDIO                                            */}
              {/* ========================================================================= */}
              {modalTab === 'overview' && (
                <div className="space-y-6">
                  {/* Template Picker Banner */}
                  <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3 bg-slate-100 dark:bg-slate-800/80 p-4 rounded-2xl border border-slate-200 dark:border-slate-700">
                    <div className="flex items-center gap-3">
                      <div className="w-10 h-10 rounded-xl bg-slate-900 dark:bg-white text-white dark:text-slate-900 flex items-center justify-center shrink-0 shadow-xs">
                        <Sparkles size={20} />
                      </div>
                      <div>
                        <h4 className="font-extrabold text-slate-900 dark:text-white text-sm">
                          {lang === 'am' ? 'የክሊኒካል ትምህርት አብነት (Clinical Templates)' : 'Clinical Curriculum Template Library'}
                        </h4>
                        <p className="text-xs text-slate-600 dark:text-slate-400">
                          {lang === 'am'
                            ? 'በአንድ ክሊክ የተረጋገጡ የጤና ትምህርቶችን፣ ማስታወሻዎችንና ፈተናዎችን በቀጥታ ይጫኑ'
                            : 'Load verified, multi-section adolescent health topics, doctor notes, and questions with 1-click'}
                        </p>
                      </div>
                    </div>

                    <button
                      type="button"
                      onClick={() => setShowTemplatePicker(!showTemplatePicker)}
                      className="px-3.5 py-2 bg-white dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-xs font-extrabold text-slate-800 dark:text-slate-200 hover:bg-slate-50 dark:hover:bg-slate-700 cursor-pointer transition-all shrink-0 flex items-center gap-1.5 shadow-2xs"
                    >
                      <LayoutTemplate size={14} />
                      <span>{showTemplatePicker ? (lang === 'am' ? 'አብነቶችን ዝጋ' : 'Close Templates') : (lang === 'am' ? 'አብነቶችን ተመልከት' : 'Browse Templates')}</span>
                    </button>
                  </div>

                  {/* Template Gallery Accordion */}
                  {showTemplatePicker && (
                    <div className="bg-white dark:bg-slate-900 rounded-2xl border border-slate-200 dark:border-slate-800 p-5 shadow-sm space-y-3 animate-in fade-in duration-150">
                      <h5 className="font-extrabold text-xs text-slate-400 uppercase tracking-wider">
                        {lang === 'am' ? 'ዝግጁ የጤና ትምህርት አብነቶች' : 'Available Clinical Starter Templates'}
                      </h5>
                      <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-3">
                        {CURRICULUM_TEMPLATES.map((tmpl) => (
                          <button
                            key={tmpl.id}
                            type="button"
                            onClick={() => applyTemplate(tmpl)}
                            className="text-left p-3.5 rounded-xl border border-slate-200 dark:border-slate-800 bg-slate-50/60 dark:bg-slate-800/40 hover:border-slate-900 dark:hover:border-white hover:bg-slate-100 dark:hover:bg-slate-800 transition-all cursor-pointer group flex flex-col justify-between"
                          >
                            <div>
                              <div className="flex items-center justify-between gap-1 mb-1">
                                <span className="text-[10px] font-extrabold uppercase text-slate-900 dark:text-white">
                                  {tmpl.category}
                                </span>
                                <span className="text-[10px] text-slate-400 font-semibold">
                                  {tmpl.readTimeMin} min read
                                </span>
                              </div>
                              <h5 className="font-extrabold text-slate-900 dark:text-white text-xs mb-1 group-hover:text-slate-950 dark:group-hover:text-white">
                                {lang === 'am' ? tmpl.nameAm : tmpl.nameEn}
                              </h5>
                              <p className="text-[11px] text-slate-500 dark:text-slate-400 line-clamp-2">
                                {lang === 'am' ? tmpl.summaryAm : tmpl.summaryEn}
                              </p>
                            </div>
                            <span className="mt-2 text-[11px] font-extrabold text-slate-900 dark:text-white flex items-center gap-1">
                              <span>{lang === 'am' ? 'ተግብር' : 'Apply Template'}</span>
                              <ChevronRight size={13} />
                            </span>
                          </button>
                        ))}
                      </div>
                    </div>
                  )}

                  {/* Core Module Metadata Card */}
                  <div className="bg-white dark:bg-slate-900 rounded-2xl border border-slate-200/80 dark:border-slate-800 p-6 shadow-xs space-y-5">
                    <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                      <div>
                        <label className="block font-bold text-slate-700 dark:text-slate-300 text-xs mb-1.5">
                          {lang === 'am' ? 'የትምህርት ዘርፍ (Category)' : 'Health Category'}
                        </label>
                        <select
                          value={formData.category}
                          onChange={(e) => {
                            const newCat = e.target.value;
                            const matchingImg = OFFICIAL_ILLUSTRATIONS.find((i) => i.id === newCat)?.path;
                            setFormData({
                              ...formData,
                              category: newCat,
                              imageUrl: matchingImg || formData.imageUrl,
                            });
                          }}
                          className="w-full px-3 py-2 border border-slate-200 dark:border-slate-700 rounded-xl bg-slate-50/70 dark:bg-slate-800 text-slate-900 dark:text-white font-semibold text-xs focus:border-slate-900 dark:focus:border-white focus:outline-hidden"
                        >
                          <option value="puberty">Puberty & Growth (ጉርምስና)</option>
                          <option value="srh">Sexual & Reproductive Health (ሥነ-ተዋልዶ)</option>
                          <option value="sti">STI Prevention (የአባላዘር በሽታዎች)</option>
                          <option value="hiv">HIV & AIDS Prevention (ኤች.አይ.ቪ)</option>
                          <option value="hepatitis">Viral Hepatitis (የጉበት ቫይረስ)</option>
                          <option value="mental_health">Mental Health & Stress (አእምሮ ጤና)</option>
                          <option value="gbv">GBV & Consent (ጾታዊ ጥቃት)</option>
                          <option value="substance">Substance Abuse (የሱስ መከላከል)</option>
                        </select>
                      </div>

                      <div>
                        <div className="flex items-center justify-between mb-1.5">
                          <label className="block font-bold text-slate-700 dark:text-slate-300 text-xs">
                            {lang === 'am' ? 'የንባብ ጊዜ (ደቂቃ)' : 'Estimated Reading Time'}
                          </label>
                          <button
                            type="button"
                            onClick={calculateReadingTime}
                            className="text-[10px] font-extrabold text-[#0284C7] hover:underline flex items-center gap-1 cursor-pointer"
                            title="Calculate based on word count"
                          >
                            <Sparkles size={11} />
                            <span>{lang === 'am' ? 'በይዘት አስላ' : 'Auto-calc'}</span>
                          </button>
                        </div>
                        <div className="relative">
                          <input
                            type="number"
                            min={1}
                            max={30}
                            value={formData.readTimeMin}
                            onChange={(e) =>
                              setFormData({
                                ...formData,
                                readTimeMin: parseInt(e.target.value, 10) || 4,
                              })
                            }
                            className="w-full px-3 py-2 border border-slate-200 dark:border-slate-700 rounded-xl bg-slate-50/70 dark:bg-slate-800 text-slate-900 dark:text-white font-semibold text-xs focus:border-slate-900 dark:focus:border-white focus:outline-hidden"
                          />
                          <span className="absolute right-3 top-1/2 -translate-y-1/2 text-xs text-slate-400 font-bold">
                            min
                          </span>
                        </div>
                      </div>

                      {/* Cover Illustration Selector */}
                      <div>
                        <label className="block font-bold text-slate-700 dark:text-slate-300 text-xs mb-1.5">
                          {lang === 'am' ? 'የሞጁሉ ስዕል (Cover Illustration)' : 'Cover Illustration'}
                        </label>
                        <div className="flex items-center gap-2">
                          <div className="w-10 h-10 rounded-xl bg-slate-100 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 overflow-hidden shrink-0 flex items-center justify-center p-1">
                            <img
                              src={currentThumbnailUrl}
                              alt=""
                              className="w-full h-full object-contain"
                              onError={(e) => {
                                (e.target as HTMLImageElement).src =
                                  '/illustrations/module_01_puberty.jpg';
                              }}
                            />
                          </div>
                          <button
                            type="button"
                            onClick={() => setShowImagePicker(true)}
                            className="flex-1 px-3 py-2 border border-slate-200 dark:border-slate-700 rounded-xl bg-slate-50 dark:bg-slate-800 hover:bg-slate-100 text-slate-700 dark:text-slate-300 text-xs font-bold flex items-center justify-center gap-1.5 cursor-pointer"
                          >
                            <ImageIcon size={14} />
                            <span>{lang === 'am' ? 'ስዕል ምረጥ' : 'Choose Cover'}</span>
                          </button>
                        </div>
                      </div>
                    </div>

                    {/* Titles */}
                    <div className={`grid gap-4 ${viewMode === 'split' ? 'grid-cols-1 md:grid-cols-2' : 'grid-cols-1'}`}>
                      {(viewMode === 'split' || viewMode === 'en') && (
                        <div>
                          <label className="block font-bold text-slate-700 dark:text-slate-300 text-xs mb-1.5">
                            Module Title (English) *
                          </label>
                          <input
                            type="text"
                            required
                            value={formData.titleEn}
                            onChange={(e) =>
                              setFormData({ ...formData, titleEn: e.target.value })
                            }
                            placeholder="e.g. Adolescent health & puberty"
                            className="w-full px-3.5 py-2.5 border border-slate-200 dark:border-slate-700 rounded-xl bg-white dark:bg-slate-850 text-slate-900 dark:text-white font-extrabold text-sm focus:border-slate-900 dark:focus:border-white focus:outline-hidden"
                          />
                        </div>
                      )}

                      {(viewMode === 'split' || viewMode === 'am') && (
                        <div>
                          <label className="block font-bold text-slate-700 dark:text-slate-300 text-xs mb-1.5">
                            የሞጁሉ ርዕስ (በአማርኛ) *
                          </label>
                          <input
                            type="text"
                            required
                            value={formData.titleAm}
                            onChange={(e) =>
                              setFormData({ ...formData, titleAm: e.target.value })
                            }
                            placeholder="ምሳሌ፡ የጉርምስና ወቅትና አካላዊ ለውጦች"
                            className="w-full px-3.5 py-2.5 border border-slate-200 dark:border-slate-700 rounded-xl bg-white dark:bg-slate-850 text-slate-900 dark:text-white font-extrabold text-sm focus:border-slate-900 dark:focus:border-white focus:outline-hidden"
                          />
                        </div>
                      )}
                    </div>

                    {/* Author Attribution */}
                    <div>
                      <label className="block font-bold text-slate-700 dark:text-slate-300 text-xs mb-1.5">
                        {lang === 'am' ? 'ክሊኒካል ደራሲ ወይም የህክምና ቡድን' : 'Author or Medical Review Team'}
                      </label>
                      <input
                        type="text"
                        value={formData.authorName}
                        onChange={(e) =>
                          setFormData({ ...formData, authorName: e.target.value })
                        }
                        placeholder="e.g. Dr. Hanna Bekele, Adolescent Specialist"
                        className="w-full px-3 py-2 border border-slate-200 dark:border-slate-700 rounded-xl bg-white dark:bg-slate-850 text-slate-900 dark:text-white text-xs font-semibold focus:border-slate-900 dark:focus:border-white focus:outline-hidden"
                      />
                    </div>

                    {/* Summaries */}
                    <div className={`grid gap-4 ${viewMode === 'split' ? 'grid-cols-1 md:grid-cols-2' : 'grid-cols-1'}`}>
                      {(viewMode === 'split' || viewMode === 'en') && (
                        <div>
                          <label className="block font-bold text-slate-700 dark:text-slate-300 text-xs mb-1.5">
                            Overview Summary (English) *
                          </label>
                          <textarea
                            rows={3}
                            required
                            value={formData.summaryEn}
                            onChange={(e) =>
                              setFormData({ ...formData, summaryEn: e.target.value })
                            }
                            placeholder="Clear, engaging 1-2 sentence overview of this health curriculum topic..."
                            className="w-full px-3.5 py-2.5 border border-slate-200 dark:border-slate-700 rounded-xl bg-white dark:bg-slate-850 text-slate-900 dark:text-white text-xs focus:border-slate-900 dark:focus:border-white focus:outline-hidden leading-relaxed"
                          />
                        </div>
                      )}

                      {(viewMode === 'split' || viewMode === 'am') && (
                        <div>
                          <label className="block font-bold text-slate-700 dark:text-slate-300 text-xs mb-1.5">
                            አጠቃላይ ማጠቃለያ (በአማርኛ) *
                          </label>
                          <textarea
                            rows={3}
                            required
                            value={formData.summaryAm}
                            onChange={(e) =>
                              setFormData({ ...formData, summaryAm: e.target.value })
                            }
                            placeholder="ስለዚህ የጤና ትምህርት የተዘጋጀ አጭር ባለ 1-2 ዓረፍተ ነገር ማጠቃለያ..."
                            className="w-full px-3.5 py-2.5 border border-slate-200 dark:border-slate-700 rounded-xl bg-white dark:bg-slate-850 text-slate-900 dark:text-white text-xs focus:border-slate-900 dark:focus:border-white focus:outline-hidden leading-relaxed"
                          />
                        </div>
                      )}
                    </div>
                  </div>

                  {/* Step Forward Action Button */}
                  <div className="flex justify-end pt-2">
                    <button
                      type="button"
                      onClick={() => setModalTab('note')}
                      className="px-5 py-2.5 bg-slate-950 hover:bg-slate-800 dark:bg-white dark:hover:bg-slate-100 text-white dark:text-slate-950 rounded-xl text-xs font-extrabold cursor-pointer transition-all flex items-center gap-1.5 border border-slate-900 dark:border-white shadow-xs active:scale-[0.99]"
                    >
                      <span>{lang === 'am' ? 'ቀጣይ፡ የዶክተር ማስታወሻ' : 'Next: Doctor Takeaway Note'}</span>
                      <ChevronRight size={14} />
                    </button>
                  </div>
                </div>
              )}

              {/* ========================================================================= */}
              {/* TAB 2: DOCTOR'S TAKEAWAY NOTE STUDIO                                      */}
              {/* ========================================================================= */}
              {modalTab === 'note' && (
                <div className="space-y-6">
                  {/* Doctor's Note Instruction Card */}
                  <div className="flex items-center gap-3 bg-slate-100 dark:bg-slate-800/80 border border-slate-200 dark:border-slate-700 p-4 rounded-2xl">
                    <div className="w-10 h-10 rounded-xl bg-slate-900 dark:bg-white text-white dark:text-slate-900 flex items-center justify-center shrink-0 shadow-xs">
                      <Lightbulb size={20} />
                    </div>
                    <div>
                      <h4 className="font-extrabold text-slate-900 dark:text-white text-sm">
                        {lang === 'am' ? 'የዶክተር ቁልፍ ማስታወሻ (| Note Callout)' : 'Doctor’s Key Takeaway Note'}
                      </h4>
                      <p className="text-xs text-slate-600 dark:text-slate-400">
                        {lang === 'am'
                          ? 'ይህ ማስታወሻ በሞባይል አፑ ላይ ከዋናው ካርድ ስር ባለው ሰማያዊ ሳጥን ውስጥ ጎልቶ ይታያል'
                          : 'This advice appears prominently in the mobile app inside the highlighted lightbulb card right below the cover illustration'}
                      </p>
                    </div>
                  </div>

                  {/* Bilingual Note Inputs */}
                  <div className="bg-white dark:bg-slate-900 rounded-2xl border border-slate-200/80 dark:border-slate-800 p-6 shadow-xs space-y-4">
                    <div className={`grid gap-4 ${viewMode === 'split' ? 'grid-cols-1 md:grid-cols-2' : 'grid-cols-1'}`}>
                      {(viewMode === 'split' || viewMode === 'en') && (
                        <div>
                          <div className="flex items-center justify-between mb-1.5">
                            <label className="font-bold text-slate-800 dark:text-slate-200 text-xs">
                              Doctor Takeaway Note (English)
                            </label>
                            <span className="text-[11px] text-slate-400">
                              {formData.doctorNoteEn.length} chars
                            </span>
                          </div>
                          <textarea
                            rows={4}
                            value={formData.doctorNoteEn}
                            onChange={(e) =>
                              setFormData({ ...formData, doctorNoteEn: e.target.value })
                            }
                            placeholder="e.g. Every adolescent experiences puberty at their own unique pace—practicing good hygiene, understanding bodily changes, and embracing self-confidence helps ensure a healthy transition."
                            className="w-full px-3.5 py-2.5 border border-slate-200 dark:border-slate-700 rounded-xl bg-slate-50/50 dark:bg-slate-850 text-slate-900 dark:text-white text-xs focus:border-[#0284C7] focus:outline-hidden leading-relaxed"
                          />
                        </div>
                      )}

                      {(viewMode === 'split' || viewMode === 'am') && (
                        <div>
                          <div className="flex items-center justify-between mb-1.5">
                            <label className="font-bold text-slate-800 dark:text-slate-200 text-xs">
                              የዶክተር ማስታወሻ (በአማርኛ)
                            </label>
                            <span className="text-[11px] text-slate-400">
                              {formData.doctorNoteAm.length} chars
                            </span>
                          </div>
                          <textarea
                            rows={4}
                            value={formData.doctorNoteAm}
                            onChange={(e) =>
                              setFormData({ ...formData, doctorNoteAm: e.target.value })
                            }
                            placeholder="ምሳሌ፡ እያንዳንዱ ታዳጊ በራሱ ተፈጥሯዊ ፍጥነት ያድጋል፤ ንፅህናን መጠበቅ፣ የአካል ለውጦችን መረዳትና በራስ መተማመንን ማዳበር ጤናማ ሽግግርን ያረጋግጣል።"
                            className="w-full px-3.5 py-2.5 border border-slate-200 dark:border-slate-700 rounded-xl bg-slate-50/50 dark:bg-slate-850 text-slate-900 dark:text-white text-xs focus:border-[#0284C7] focus:outline-hidden leading-relaxed"
                          />
                        </div>
                      )}
                    </div>
                  </div>

                  {/* Live Card Preview Box */}
                  <div className="bg-[#EFF7FD] border border-[#BAE6FD] rounded-2xl p-4 sm:p-5 flex items-start gap-3.5">
                    <div className="w-8 h-8 rounded-full bg-[#0284C7] text-white flex items-center justify-center shrink-0 shadow-xs">
                      <Lightbulb size={16} />
                    </div>
                    <div className="min-w-0 flex-1">
                      <span className="text-[10px] font-extrabold uppercase text-[#0284C7] tracking-wider block mb-1">
                        Mobile App Callout Preview
                      </span>
                      <p className="text-xs text-[#0F172A] leading-relaxed">
                        {lang === 'am'
                          ? formData.doctorNoteAm || formData.doctorNoteEn || 'የዶክተር ማስታወሻ እዚህ ይታያል...'
                          : formData.doctorNoteEn || formData.doctorNoteAm || 'Doctor note takeaway preview will appear here...'}
                      </p>
                    </div>
                  </div>

                  {/* Tab Navigation Actions */}
                  <div className="flex justify-between pt-2">
                    <button
                      type="button"
                      onClick={() => setModalTab('overview')}
                      className="px-4 py-2 border border-slate-200 dark:border-slate-700 rounded-xl text-xs font-bold text-slate-700 dark:text-slate-300 hover:bg-slate-50 cursor-pointer"
                    >
                      ← {lang === 'am' ? 'ተመለስ' : 'Back: Overview'}
                    </button>
                    <button
                      type="button"
                      onClick={() => setModalTab('sections')}
                      className="px-5 py-2.5 bg-slate-950 hover:bg-slate-800 dark:bg-white dark:hover:bg-slate-100 text-white dark:text-slate-950 rounded-xl text-xs font-extrabold cursor-pointer transition-all flex items-center gap-1.5 border border-slate-900 dark:border-white shadow-xs active:scale-[0.99]"
                    >
                      <span>{lang === 'am' ? 'ቀጣይ፡ የትምህርት ክፍሎች' : 'Next: Learning Sections'}</span>
                      <ChevronRight size={14} />
                    </button>
                  </div>
                </div>
              )}

              {/* ========================================================================= */}
              {/* TAB 3: CURRICULUM LEARNING SECTIONS BUILDER                               */}
              {/* ========================================================================= */}
              {modalTab === 'sections' && (
                <div className="space-y-6">
                  {/* Mode & Action Toolbar */}
                  <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3 bg-white dark:bg-slate-900 p-4 rounded-2xl border border-slate-200/80 dark:border-slate-800 shadow-xs">
                    <div className="flex items-center gap-2.5">
                      <div className="w-8 h-8 rounded-xl bg-slate-100 dark:bg-slate-800 text-slate-900 dark:text-white flex items-center justify-center font-extrabold text-sm border border-slate-200 dark:border-slate-700">
                        <Layers size={16} />
                      </div>
                      <div>
                        <h4 className="font-extrabold text-slate-900 dark:text-white text-sm">
                          {lang === 'am' ? 'የትምህርት ክፍሎች' : 'Curriculum Learning Sections'}
                        </h4>
                        <p className="text-[11px] text-slate-400">
                          {sections.length} {lang === 'am' ? 'ክፍሎች ተዘጋጅተዋል' : 'sections active'} • {lang === 'am' ? 'በሞባይል አኮርዲዮን መልክ ይታያሉ' : 'expandable accordion cards on mobile'}
                        </p>
                      </div>
                    </div>

                    <div className="flex items-center gap-2 self-end sm:self-auto">
                      <button
                        type="button"
                        onClick={expandedSections.size === sections.length ? collapseAllSections : expandAllSections}
                        className="px-3 py-1.5 rounded-xl border border-slate-200 dark:border-slate-700 bg-slate-50 dark:bg-slate-800 hover:bg-slate-100 dark:hover:bg-slate-700 text-slate-600 dark:text-slate-300 text-xs font-bold transition-all cursor-pointer"
                      >
                        {expandedSections.size === sections.length
                          ? (lang === 'am' ? 'ሁሉንም አሳንስ' : 'Collapse All')
                          : (lang === 'am' ? 'ሁሉንም አሳይ' : 'Expand All')}
                      </button>

                      <div className="flex items-center bg-slate-100 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl p-0.5 text-xs font-bold">
                        <button
                          type="button"
                          onClick={() => handleToggleSectionMode('form')}
                          className={`px-2.5 py-1 rounded-lg transition-all cursor-pointer ${
                            sectionEditMode === 'form'
                              ? 'bg-slate-950 dark:bg-white text-white dark:text-slate-950 shadow-xs'
                              : 'text-slate-500 hover:text-slate-800 dark:hover:text-white'
                          }`}
                        >
                          {lang === 'am' ? 'ቀላል ፎርም' : 'Visual Form'}
                        </button>
                        <button
                          type="button"
                          onClick={() => handleToggleSectionMode('markdown')}
                          className={`px-2.5 py-1 rounded-lg transition-all cursor-pointer ${
                            sectionEditMode === 'markdown'
                              ? 'bg-slate-950 dark:bg-white text-white dark:text-slate-950 shadow-xs'
                              : 'text-slate-500 hover:text-slate-800 dark:hover:text-white'
                          }`}
                        >
                          Markdown
                        </button>
                      </div>

                      {sectionEditMode === 'form' && (
                        <>
                          <button
                            type="button"
                            onClick={handleMirrorToAmharic}
                            className="px-3 py-1.5 rounded-xl border border-sky-200 dark:border-sky-800 bg-sky-50 dark:bg-sky-950/50 hover:bg-sky-100 dark:hover:bg-sky-900/50 text-[#0284C7] dark:text-sky-300 text-xs font-bold transition-all cursor-pointer flex items-center gap-1.5 shadow-2xs"
                            title="Mirror English structure, titles, and points to Amharic placeholders"
                          >
                            <Copy size={13} />
                            <span>{lang === 'am' ? 'ወደ አማርኛ ቅዳ' : 'Mirror to Amharic'}</span>
                          </button>
                          <button
                            type="button"
                            onClick={handleAddSection}
                            className="px-3.5 py-1.5 bg-slate-950 hover:bg-slate-800 dark:bg-white dark:hover:bg-slate-100 text-white dark:text-slate-950 rounded-xl text-xs font-extrabold flex items-center gap-1.5 border border-slate-900 dark:border-white shadow-xs cursor-pointer transition-all active:scale-[0.99]"
                          >
                            <Plus size={14} />
                            <span>{lang === 'am' ? 'አዲስ ክፍል' : 'Add Section'}</span>
                          </button>
                        </>
                      )}
                    </div>
                  </div>

                  {/* FORM MODE: ACCORDION SECTION CARDS */}
                  {sectionEditMode === 'form' ? (
                    <div className="space-y-4">
                      {sections.map((sec, secIdx) => {
                        const isExpanded = expandedSections.has(secIdx);
                        const cleanBulletsCount = sec.bulletsEn.filter(Boolean).length;
                        const hasTip = Boolean(sec.tipEn || sec.tipAm);

                        return (
                          <div
                            key={sec.id}
                            className="bg-white dark:bg-slate-900 border border-slate-200/80 dark:border-slate-800 rounded-2xl shadow-xs overflow-hidden transition-all"
                          >
                            {/* Accordion Card Header */}
                            <div
                              onClick={() => toggleSectionExpanded(secIdx)}
                              className="px-5 py-4 flex items-center justify-between gap-3 cursor-pointer hover:bg-slate-50/60 dark:hover:bg-slate-850/50 transition-colors select-none"
                            >
                              <div className="flex items-center gap-3 min-w-0">
                                <div className="w-8 h-8 rounded-full bg-[#0284C7] text-white flex items-center justify-center font-extrabold text-xs shrink-0 shadow-xs">
                                  {secIdx + 1}
                                </div>
                                <div className="min-w-0">
                                  <h5 className="font-extrabold text-slate-900 dark:text-white text-sm truncate">
                                    {sec.titleEn.trim() || sec.titleAm.trim() || `Section ${secIdx + 1}`}
                                  </h5>
                                  <div className="flex items-center gap-2 mt-0.5">
                                    <span className="text-[11px] text-slate-400 truncate">
                                      {sec.titleAm.trim() && sec.titleAm !== sec.titleEn ? sec.titleAm : ''}
                                    </span>
                                    <span className="text-[10px] font-semibold bg-slate-100 dark:bg-slate-800 text-slate-500 dark:text-slate-400 px-2 py-0.2 rounded-full">
                                      {cleanBulletsCount} {cleanBulletsCount === 1 ? 'point' : 'points'}
                                    </span>
                                    {hasTip && (
                                      <span className="text-[10px] font-semibold bg-emerald-50 dark:bg-emerald-950/50 text-emerald-700 dark:text-emerald-400 px-2 py-0.2 rounded-full border border-emerald-200/60 dark:border-emerald-800/40">
                                        Clinical Tip
                                      </span>
                                    )}
                                    {sec.videoUrl && (
                                      <span className="text-[10px] font-semibold bg-red-50 dark:bg-rose-950/50 text-red-700 dark:text-rose-400 px-2 py-0.2 rounded-full border border-red-200/60 dark:border-rose-800/40 flex items-center gap-1">
                                        <Video size={10} /> Video
                                      </span>
                                    )}
                                  </div>
                                </div>
                              </div>

                              <div className="flex items-center gap-1.5 shrink-0" onClick={(e) => e.stopPropagation()}>
                                <button
                                  type="button"
                                  disabled={secIdx === 0}
                                  onClick={() => handleMoveSection(secIdx, 'up')}
                                  className="p-1.5 text-slate-400 hover:text-slate-700 dark:hover:text-slate-200 hover:bg-slate-100 dark:hover:bg-slate-800 rounded-lg disabled:opacity-30 cursor-pointer"
                                  title="Move Up"
                                >
                                  <ChevronUp size={15} />
                                </button>
                                <button
                                  type="button"
                                  disabled={secIdx === sections.length - 1}
                                  onClick={() => handleMoveSection(secIdx, 'down')}
                                  className="p-1.5 text-slate-400 hover:text-slate-700 dark:hover:text-slate-200 hover:bg-slate-100 dark:hover:bg-slate-800 rounded-lg disabled:opacity-30 cursor-pointer"
                                  title="Move Down"
                                >
                                  <ChevronDown size={15} />
                                </button>
                                <button
                                  type="button"
                                  disabled={sections.length <= 1}
                                  onClick={() => handleRemoveSection(secIdx)}
                                  className="p-1.5 text-slate-400 hover:text-rose-600 dark:hover:text-rose-400 hover:bg-rose-50 dark:hover:bg-rose-950/40 rounded-lg disabled:opacity-30 cursor-pointer"
                                  title="Delete Section"
                                >
                                  <Trash2 size={15} />
                                </button>
                                <div className="h-4 w-px bg-slate-200 dark:bg-slate-700 mx-0.5" />
                                <div className="p-1 text-slate-400">
                                  {isExpanded ? <ChevronUp size={16} /> : <ChevronDown size={16} />}
                                </div>
                              </div>
                            </div>

                            {/* Accordion Card Body (When Expanded) */}
                            {isExpanded && (
                              <div className="px-5 pb-5 pt-2 border-t border-slate-100 dark:border-slate-800/80 space-y-5 bg-slate-50/30 dark:bg-slate-900/40">
                                {/* 1. Section Title & Explanatory Introduction */}
                                <div className={`grid gap-4 ${viewMode === 'split' ? 'grid-cols-1 md:grid-cols-2' : 'grid-cols-1'}`}>
                                  {(viewMode === 'split' || viewMode === 'en') && (
                                    <div className="space-y-3">
                                      <div>
                                        <label className="block font-bold text-slate-700 dark:text-slate-300 text-xs mb-1">
                                          Section Title (English) *
                                        </label>
                                        <input
                                          type="text"
                                          value={sec.titleEn}
                                          onChange={(e) =>
                                            handleUpdateSection(secIdx, 'titleEn', e.target.value)
                                          }
                                          placeholder="e.g. Understanding Puberty & Adolescence"
                                          className="w-full px-3 py-2 border border-slate-200 dark:border-slate-700 rounded-xl bg-white dark:bg-slate-850 text-slate-900 dark:text-white font-extrabold text-xs focus:border-[#0284C7] focus:outline-hidden"
                                        />
                                      </div>
                                      <div>
                                        <label className="block font-bold text-slate-700 dark:text-slate-300 text-xs mb-1">
                                          Section Intro / Overview (English)
                                        </label>
                                        <textarea
                                          rows={2}
                                          value={sec.bodyEn}
                                          onChange={(e) =>
                                            handleUpdateSection(secIdx, 'bodyEn', e.target.value)
                                          }
                                          placeholder="Clinical introduction explaining this section's core topic..."
                                          className="w-full px-3 py-2 border border-slate-200 dark:border-slate-700 rounded-xl bg-white dark:bg-slate-850 text-slate-900 dark:text-white text-xs focus:border-[#0284C7] focus:outline-hidden leading-relaxed"
                                        />
                                      </div>
                                    </div>
                                  )}

                                  {(viewMode === 'split' || viewMode === 'am') && (
                                    <div className="space-y-3">
                                      <div>
                                        <label className="block font-bold text-slate-700 dark:text-slate-300 text-xs mb-1">
                                          የክፍሉ ርዕስ (በአማርኛ) *
                                        </label>
                                        <input
                                          type="text"
                                          value={sec.titleAm}
                                          onChange={(e) =>
                                            handleUpdateSection(secIdx, 'titleAm', e.target.value)
                                          }
                                          placeholder="ምሳሌ፡ የጉርምስና ወቅትና ሽግግርን መረዳት"
                                          className="w-full px-3 py-2 border border-slate-200 dark:border-slate-700 rounded-xl bg-white dark:bg-slate-850 text-slate-900 dark:text-white font-extrabold text-xs focus:border-[#0284C7] focus:outline-hidden"
                                        />
                                      </div>
                                      <div>
                                        <label className="block font-bold text-slate-700 dark:text-slate-300 text-xs mb-1">
                                          የክፍሉ ማብራሪያ (በአማርኛ)
                                        </label>
                                        <textarea
                                          rows={2}
                                          value={sec.bodyAm}
                                          onChange={(e) =>
                                            handleUpdateSection(secIdx, 'bodyAm', e.target.value)
                                          }
                                          placeholder="ስለዚህ ክፍል የሚሰጥ አጠቃላይ ክሊኒካዊ መግቢያ..."
                                          className="w-full px-3 py-2 border border-slate-200 dark:border-slate-700 rounded-xl bg-white dark:bg-slate-850 text-slate-900 dark:text-white text-xs focus:border-[#0284C7] focus:outline-hidden leading-relaxed"
                                        />
                                      </div>
                                    </div>
                                  )}
                                </div>

                                {/* 2. Key Takeaways (Bullet Items) */}
                                <div className="space-y-2.5 pt-2 border-t border-slate-200/60 dark:border-slate-800">
                                  <div className="flex items-center justify-between">
                                    <span className="font-extrabold text-slate-700 dark:text-slate-300 text-xs flex items-center gap-1.5">
                                      <List size={14} className="text-[#0284C7]" />
                                      <span>
                                        {lang === 'am'
                                          ? 'ዋና ዋና ነጥቦች (Key Takeaways / Bullets)'
                                          : 'Key Learning Takeaways (Bullet Points)'}
                                      </span>
                                    </span>
                                    <button
                                      type="button"
                                      onClick={() => handleAddBullet(secIdx)}
                                      className="px-2.5 py-1 bg-slate-100 hover:bg-slate-200 dark:bg-slate-800 dark:hover:bg-slate-700 text-slate-800 dark:text-slate-200 rounded-lg text-[11px] font-extrabold flex items-center gap-1 cursor-pointer transition-colors border border-slate-200 dark:border-slate-700"
                                    >
                                      <Plus size={12} />
                                      <span>{lang === 'am' ? '+ ነጥብ ጨምር' : '+ Add Takeaway Point'}</span>
                                    </button>
                                  </div>

                                  <div className="space-y-2">
                                    {sec.bulletsEn.map((_, bIdx) => (
                                      <div
                                        key={bIdx}
                                        className="flex items-center gap-2 bg-white dark:bg-slate-850 p-1.5 rounded-xl border border-slate-200/70 dark:border-slate-750"
                                      >
                                        <div className="w-6 h-6 rounded-lg bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-300 font-extrabold text-[10px] flex items-center justify-center shrink-0">
                                          {(bIdx + 1).toString().padStart(2, '0')}
                                        </div>

                                        {(viewMode === 'split' || viewMode === 'en') && (
                                          <input
                                            type="text"
                                            value={sec.bulletsEn[bIdx] || ''}
                                            onChange={(e) =>
                                              handleUpdateBullet(secIdx, bIdx, 'en', e.target.value)
                                            }
                                            placeholder={`Point ${bIdx + 1} (English)...`}
                                            className="flex-1 px-2.5 py-1 text-xs bg-transparent text-slate-900 dark:text-white placeholder:text-slate-400 focus:outline-hidden"
                                          />
                                        )}

                                        {(viewMode === 'split' || viewMode === 'am') && (
                                          <input
                                            type="text"
                                            value={sec.bulletsAm[bIdx] || ''}
                                            onChange={(e) =>
                                              handleUpdateBullet(secIdx, bIdx, 'am', e.target.value)
                                            }
                                            placeholder={`ነጥብ ${bIdx + 1} (በአማርኛ)...`}
                                            className="flex-1 px-2.5 py-1 text-xs bg-transparent text-slate-900 dark:text-white placeholder:text-slate-400 focus:outline-hidden"
                                          />
                                        )}

                                        {sec.bulletsEn.length > 1 && (
                                          <button
                                            type="button"
                                            onClick={() => handleRemoveBullet(secIdx, bIdx)}
                                            className="p-1 text-slate-400 hover:text-rose-600 rounded cursor-pointer"
                                            title="Delete Point"
                                          >
                                            <X size={14} />
                                          </button>
                                        )}
                                      </div>
                                    ))}
                                  </div>
                                </div>

                                {/* 3. Clinical Tip Box */}
                                <div className="bg-[#F0FDF4] dark:bg-emerald-950/20 border border-[#BBF7D0] dark:border-emerald-800/40 rounded-xl p-3.5 space-y-2">
                                  <div className="flex items-center gap-1.5 text-[11px] font-extrabold text-[#166534] dark:text-emerald-400 uppercase tracking-wide">
                                    <HeartPulse size={14} className="text-[#16A34A]" />
                                    <span>
                                      {lang === 'am' ? 'የዶክተር ክሊኒካል ምክር (Clinical Tip)' : 'Clinical Tip & Adolescent Guidance'}
                                    </span>
                                  </div>

                                  <div className={`grid gap-2.5 ${viewMode === 'split' ? 'grid-cols-1 md:grid-cols-2' : 'grid-cols-1'}`}>
                                    {(viewMode === 'split' || viewMode === 'en') && (
                                      <input
                                        type="text"
                                        value={sec.tipEn}
                                        onChange={(e) =>
                                          handleUpdateSection(secIdx, 'tipEn', e.target.value)
                                        }
                                        placeholder="Clinical tip in English (e.g. Wash your face twice daily with mild soap to manage skin oil balance)..."
                                        className="w-full px-3 py-1.5 text-xs rounded-lg border border-[#86EFAC] dark:border-emerald-800 bg-white dark:bg-slate-850 text-slate-900 dark:text-white focus:outline-hidden"
                                      />
                                    )}

                                    {(viewMode === 'split' || viewMode === 'am') && (
                                      <input
                                        type="text"
                                        value={sec.tipAm}
                                        onChange={(e) =>
                                          handleUpdateSection(secIdx, 'tipAm', e.target.value)
                                        }
                                        placeholder="ክሊኒካዊ ምክር በአማርኛ (ምሳሌ፡ ፊትዎን በቀን ሁለት ጊዜ ለስላሳ ሳሙና መታጠብ የቆዳ ቅባትን ለመቆጣጠር ይረዳል።)..."
                                        className="w-full px-3 py-1.5 text-xs rounded-lg border border-[#86EFAC] dark:border-emerald-800 bg-white dark:bg-slate-850 text-slate-900 dark:text-white focus:outline-hidden"
                                      />
                                    )}
                                  </div>
                                </div>

                                {/* 4. Optional YouTube Video Box */}
                                {(() => {
                                  const ytId = extractYoutubeId(sec.videoUrl);
                                  return (
                                    <div className="bg-red-50/60 dark:bg-rose-950/20 border border-red-200/80 dark:border-rose-900/40 rounded-xl p-3.5 space-y-2.5">
                                      <div className="flex items-center justify-between">
                                        <div className="flex items-center gap-1.5 text-[11px] font-extrabold text-red-700 dark:text-rose-400 uppercase tracking-wide">
                                          <Video size={14} className="text-red-600 dark:text-rose-400" />
                                          <span>
                                            {lang === 'am' ? 'አማራጭ የዩቲዩብ ቪዲዮ (YouTube Video)' : 'Optional Educational Video (YouTube)'}
                                          </span>
                                        </div>
                                        {sec.videoUrl && (
                                          <button
                                            type="button"
                                            onClick={() => handleUpdateSection(secIdx, 'videoUrl', '')}
                                            className="text-[11px] font-bold text-slate-400 hover:text-red-600 transition-colors cursor-pointer"
                                          >
                                            {lang === 'am' ? 'አስወግድ' : 'Clear Video'}
                                          </button>
                                        )}
                                      </div>

                                      <div className="flex items-center gap-2">
                                        <input
                                          type="text"
                                          value={sec.videoUrl || ''}
                                          onChange={(e) =>
                                            handleUpdateSection(secIdx, 'videoUrl', e.target.value)
                                          }
                                          placeholder="https://www.youtube.com/watch?v=... or https://youtu.be/..."
                                          className="flex-1 px-3 py-1.5 text-xs rounded-lg border border-red-200 dark:border-rose-800 bg-white dark:bg-slate-850 text-slate-900 dark:text-white focus:outline-hidden"
                                        />
                                      </div>

                                      {ytId && (
                                        <div className="flex items-center gap-3 bg-white dark:bg-slate-900 border border-red-200/60 dark:border-rose-900/40 rounded-lg p-2 animate-in fade-in duration-150">
                                          <div className="relative w-24 h-14 rounded-md overflow-hidden bg-slate-900 shrink-0">
                                            <img
                                              src={`https://img.youtube.com/vi/${ytId}/hqdefault.jpg`}
                                              alt="YouTube Preview"
                                              className="w-full h-full object-cover"
                                              onError={(e) => {
                                                (e.target as HTMLImageElement).src =
                                                  `https://img.youtube.com/vi/${ytId}/0.jpg`;
                                              }}
                                            />
                                            <div className="absolute inset-0 bg-black/25 flex items-center justify-center">
                                              <div className="w-6 h-6 rounded-full bg-red-600 text-white flex items-center justify-center shadow-xs">
                                                <Play size={10} className="fill-white ml-0.5" />
                                              </div>
                                            </div>
                                          </div>
                                          <div className="min-w-0 flex-1">
                                            <div className="flex items-center gap-1.5">
                                              <span className="px-1.5 py-0.5 rounded text-[9px] font-extrabold bg-red-100 dark:bg-rose-950 text-red-700 dark:text-rose-300">
                                                YouTube ID: {ytId}
                                              </span>
                                            </div>
                                            <p className="text-[11px] text-slate-500 dark:text-slate-400 mt-1 truncate">
                                              {sec.videoUrl}
                                            </p>
                                          </div>
                                          <a
                                            href={sec.videoUrl?.startsWith('http') ? sec.videoUrl : `https://www.youtube.com/watch?v=${ytId}`}
                                            target="_blank"
                                            rel="noreferrer"
                                            className="p-1.5 text-slate-400 hover:text-slate-700 dark:hover:text-white cursor-pointer"
                                            title="Open in YouTube"
                                          >
                                            <ExternalLink size={14} />
                                          </a>
                                        </div>
                                      )}
                                    </div>
                                  );
                                })()}
                              </div>
                            )}
                          </div>
                        );
                      })}
                    </div>
                  ) : (
                    /* RAW MARKDOWN MODE */
                    <div className="bg-white dark:bg-slate-900 rounded-2xl border border-slate-200 dark:border-slate-800 p-5 shadow-xs space-y-3">
                      <div className="flex items-center justify-between pb-2 border-b border-slate-100 dark:border-slate-800">
                        <div className="flex items-center gap-1 bg-slate-100 dark:bg-slate-800 p-1 rounded-xl">
                          <button
                            type="button"
                            onClick={() => setActiveLangTab('en')}
                            className={`px-3 py-1 rounded-lg text-xs font-bold cursor-pointer ${
                              activeLangTab === 'en'
                                ? 'bg-slate-950 dark:bg-white text-white dark:text-slate-950 shadow-xs'
                                : 'text-slate-600 dark:text-slate-300'
                            }`}
                          >
                            English Markdown
                          </button>
                          <button
                            type="button"
                            onClick={() => setActiveLangTab('am')}
                            className={`px-3 py-1 rounded-lg text-xs font-bold cursor-pointer ${
                              activeLangTab === 'am'
                                ? 'bg-slate-950 dark:bg-white text-white dark:text-slate-950 shadow-xs'
                                : 'text-slate-600 dark:text-slate-300'
                            }`}
                          >
                            የአማርኛ ማርክዳውን
                          </button>
                        </div>

                        <div className="flex items-center gap-1">
                          <button
                            type="button"
                            onClick={() => insertMarkdown('**', '**')}
                            className="p-1.5 text-slate-500 hover:text-slate-900 dark:hover:text-white hover:bg-slate-100 dark:hover:bg-slate-800 rounded"
                            title="Bold"
                          >
                            <Bold size={13} />
                          </button>
                          <button
                            type="button"
                            onClick={() => insertMarkdown('## ')}
                            className="p-1.5 text-slate-500 hover:text-slate-900 dark:hover:text-white hover:bg-slate-100 dark:hover:bg-slate-800 rounded"
                            title="H2 Section Heading"
                          >
                            <Heading2 size={13} />
                          </button>
                          <button
                            type="button"
                            onClick={() => insertMarkdown('- ')}
                            className="p-1.5 text-slate-500 hover:text-slate-900 dark:hover:text-white hover:bg-slate-100 dark:hover:bg-slate-800 rounded"
                            title="Bullet List"
                          >
                            <List size={13} />
                          </button>
                          <button
                            type="button"
                            onClick={() => insertMarkdown('> ')}
                            className="p-1.5 text-slate-500 hover:text-slate-900 dark:hover:text-white hover:bg-slate-100 dark:hover:bg-slate-800 rounded"
                            title="Clinical Tip"
                          >
                            <Quote size={13} />
                          </button>
                        </div>
                      </div>

                      <textarea
                        rows={16}
                        value={activeLangTab === 'am' ? formData.contentAm : formData.contentEn}
                        onChange={(e) => {
                          if (activeLangTab === 'am') {
                            setFormData({ ...formData, contentAm: e.target.value });
                          } else {
                            setFormData({ ...formData, contentEn: e.target.value });
                          }
                        }}
                        placeholder="Write structured markdown with ## Headings, - Bullets, and > Clinical Tips..."
                        className="w-full px-3.5 py-3 border border-slate-200 dark:border-slate-700 rounded-2xl bg-white dark:bg-slate-800 text-slate-900 dark:text-white font-mono text-xs focus:border-slate-900 dark:focus:border-white focus:outline-hidden leading-relaxed"
                      />
                    </div>
                  )}

                  {/* Tab Navigation Actions */}
                  <div className="flex justify-between pt-2">
                    <button
                      type="button"
                      onClick={() => setModalTab('note')}
                      className="px-4 py-2 border border-slate-200 dark:border-slate-700 rounded-xl text-xs font-bold text-slate-700 dark:text-slate-300 hover:bg-slate-50 cursor-pointer"
                    >
                      ← {lang === 'am' ? 'ተመለስ' : 'Back: Doctor Note'}
                    </button>
                    <button
                      type="button"
                      onClick={() => setModalTab('quizzes')}
                      className="px-5 py-2.5 bg-slate-950 hover:bg-slate-800 dark:bg-white dark:hover:bg-slate-100 text-white dark:text-slate-950 rounded-xl text-xs font-extrabold cursor-pointer transition-all flex items-center gap-1.5 border border-slate-900 dark:border-white shadow-xs active:scale-[0.99]"
                    >
                      <span>{lang === 'am' ? 'ቀጣይ፡ ፈተና ጥያቄዎች' : 'Next: Quiz Questions'}</span>
                      <ChevronRight size={14} />
                    </button>
                  </div>
                </div>
              )}

              {/* ========================================================================= */}
              {/* TAB 4: KNOWLEDGE CHECK QUIZ BUILDER                                       */}
              {/* ========================================================================= */}
              {modalTab === 'quizzes' && (
                <div className="space-y-6">
                  {/* Top Banner */}
                  <div className="flex items-center justify-between bg-amber-50/70 dark:bg-amber-950/30 border border-amber-200 dark:border-amber-900/50 p-4 rounded-2xl">
                    <div className="flex items-center gap-3">
                      <div className="w-10 h-10 rounded-xl bg-amber-500 text-white flex items-center justify-center shrink-0 shadow-xs">
                        <HelpCircle size={20} />
                      </div>
                      <div>
                        <h4 className="font-extrabold text-slate-900 dark:text-white text-sm">
                          {lang === 'am' ? 'የእውቀት መፈተሻ ጥያቄዎች (Knowledge Check Quiz)' : 'Knowledge Check Quiz Questions'}
                        </h4>
                        <p className="text-xs text-slate-600 dark:text-slate-400">
                          {lang === 'am'
                            ? 'ተማሪዎች ሞጁሉን ካጠናቀቁ በኋላ እውቀታቸውን የሚለኩባቸው ጥያቄዎች'
                            : 'Interactive assessment questions presented to learners upon finishing this module'}
                        </p>
                      </div>
                    </div>

                    <div className="flex items-center gap-2 shrink-0">
                      <button
                        type="button"
                        onClick={() => openAddQuizQuestion('MULTIPLE_CHOICE')}
                        className="px-3.5 py-2 bg-amber-600 hover:bg-amber-700 text-white rounded-xl text-xs font-extrabold flex items-center gap-1.5 shadow-sm cursor-pointer transition-all"
                      >
                        <Plus size={14} />
                        <span>{lang === 'am' ? '+ ምርጫ ጥያቄ' : '+ Multiple Choice'}</span>
                      </button>
                      <button
                        type="button"
                        onClick={() => openAddQuizQuestion('TRUE_FALSE')}
                        className="px-3.5 py-2 bg-amber-100 hover:bg-amber-200 dark:bg-amber-950/60 dark:hover:bg-amber-900/60 text-amber-900 dark:text-amber-200 border border-amber-300 dark:border-amber-800 rounded-xl text-xs font-extrabold flex items-center gap-1.5 shadow-2xs cursor-pointer transition-all"
                      >
                        <Plus size={14} />
                        <span>{lang === 'am' ? '+ እውነት/ሐሰት' : '+ True / False'}</span>
                      </button>
                    </div>
                  </div>

                  {/* Focused Question Editor Card (When active) */}
                  {quizFormOpen && (
                    <form
                      onSubmit={handleSaveQuizQuestion}
                      className="bg-white dark:bg-slate-900 border-2 border-amber-400/90 rounded-2xl p-6 shadow-md space-y-4 animate-in fade-in zoom-in-95"
                    >
                      <div className="flex items-center justify-between pb-3 border-b border-slate-100 dark:border-slate-800">
                        <h5 className="font-extrabold text-slate-900 dark:text-white text-sm flex items-center gap-2">
                          <HelpCircle size={16} className="text-amber-600" />
                          <span>
                            {editingQuizIndex !== null
                              ? lang === 'am'
                                ? 'የፈተና ጥያቄን አርትዕ'
                                : 'Edit Quiz Question'
                              : lang === 'am'
                              ? 'አዲስ የፈተና ጥያቄ ጨምር'
                              : 'Create Quiz Question'}
                          </span>
                        </h5>
                        <button
                          type="button"
                          onClick={() => setQuizFormOpen(false)}
                          className="p-1 text-slate-400 hover:text-slate-600 dark:hover:text-slate-200"
                        >
                          <X size={16} />
                        </button>
                      </div>

                      {/* Question Type Selector */}
                      <div className="flex items-center gap-3">
                        <label className="font-bold text-slate-700 dark:text-slate-300 text-xs">
                          {lang === 'am' ? 'የጥያቄ ዓይነት፡' : 'Question Type:'}
                        </label>
                        <div className="flex items-center gap-2">
                          <button
                            type="button"
                            onClick={() =>
                              setQuizFormData({
                                ...quizFormData,
                                type: 'MULTIPLE_CHOICE',
                                optionsEn:
                                  quizFormData.optionsEn.length === 4
                                    ? quizFormData.optionsEn
                                    : ['', '', '', ''],
                                optionsAm:
                                  quizFormData.optionsAm.length === 4
                                    ? quizFormData.optionsAm
                                    : ['', '', '', ''],
                                correctIndex: Math.min(quizFormData.correctIndex, 3),
                              })
                            }
                            className={`px-3 py-1.5 rounded-xl text-xs font-bold cursor-pointer transition-all ${
                              quizFormData.type === 'MULTIPLE_CHOICE'
                                ? 'bg-amber-600 text-white shadow-xs'
                                : 'bg-slate-100 dark:bg-slate-800 text-slate-700 dark:text-slate-300'
                            }`}
                          >
                            Multiple Choice (4 Choices)
                          </button>
                          <button
                            type="button"
                            onClick={() =>
                              setQuizFormData({
                                ...quizFormData,
                                type: 'TRUE_FALSE',
                                optionsEn: ['True', 'False'],
                                optionsAm: ['እውነት', 'ሐሰት'],
                                correctIndex: Math.min(quizFormData.correctIndex, 1),
                              })
                            }
                            className={`px-3 py-1.5 rounded-xl text-xs font-bold cursor-pointer transition-all ${
                              quizFormData.type === 'TRUE_FALSE'
                                ? 'bg-amber-600 text-white shadow-xs'
                                : 'bg-slate-100 dark:bg-slate-800 text-slate-700 dark:text-slate-300'
                            }`}
                          >
                            True / False (2 Choices)
                          </button>
                        </div>
                      </div>

                      {/* Question Prompts */}
                      <div className={`grid gap-4 ${viewMode === 'split' ? 'grid-cols-1 md:grid-cols-2' : 'grid-cols-1'}`}>
                        {(viewMode === 'split' || viewMode === 'en') && (
                          <div>
                            <label className="block font-bold text-slate-700 dark:text-slate-300 text-xs mb-1">
                              Question Prompt (English) *
                            </label>
                            <textarea
                              rows={2}
                              required
                              value={quizFormData.questionEn}
                              onChange={(e) =>
                                setQuizFormData({ ...quizFormData, questionEn: e.target.value })
                              }
                              placeholder="e.g. Which physical change is a typical primary milestone for adolescent males?"
                              className="w-full px-3.5 py-2 border border-slate-200 dark:border-slate-700 rounded-xl bg-white dark:bg-slate-850 text-slate-900 dark:text-white text-xs focus:border-amber-500 focus:outline-hidden"
                            />
                          </div>
                        )}

                        {(viewMode === 'split' || viewMode === 'am') && (
                          <div>
                            <label className="block font-bold text-slate-700 dark:text-slate-300 text-xs mb-1">
                              የጥያቄው ጽሑፍ (በአማርኛ) *
                            </label>
                            <textarea
                              rows={2}
                              required
                              value={quizFormData.questionAm}
                              onChange={(e) =>
                                setQuizFormData({ ...quizFormData, questionAm: e.target.value })
                              }
                              placeholder="ምሳሌ፡ በጉርምስና ወቅት በወንዶች ላይ የሚታየው ቁልፍ አካላዊ ለውጥ የትኛው ነው?"
                              className="w-full px-3.5 py-2 border border-slate-200 dark:border-slate-700 rounded-xl bg-white dark:bg-slate-850 text-slate-900 dark:text-white text-xs focus:border-amber-500 focus:outline-hidden"
                            />
                          </div>
                        )}
                      </div>

                      {/* Options Setup with Radio Selection */}
                      <div className="space-y-2 pt-2">
                        <label className="block font-bold text-slate-700 dark:text-slate-300 text-xs">
                          {lang === 'am' ? 'የመልስ አማራጮች (ትክክለኛውን መልስ በክብ ቁልፉ ይምረጡ)' : 'Answer Choices (Click radio button to mark correct answer):'}
                        </label>
                        <div className="space-y-2">
                          {quizFormData.optionsEn.map((_, oIdx) => {
                            const isCorrect = quizFormData.correctIndex === oIdx;
                            const optionLetter = String.fromCharCode(65 + oIdx);

                            return (
                              <div
                                key={oIdx}
                                className={`flex items-center gap-3 p-2.5 rounded-xl border transition-all ${
                                  isCorrect
                                    ? 'bg-emerald-50/70 dark:bg-emerald-950/30 border-emerald-400'
                                    : 'bg-white dark:bg-slate-850 border-slate-200 dark:border-slate-700'
                                }`}
                              >
                                <button
                                  type="button"
                                  onClick={() => setQuizFormData({ ...quizFormData, correctIndex: oIdx })}
                                  className={`w-6 h-6 rounded-full flex items-center justify-center font-bold text-xs shrink-0 cursor-pointer ${
                                    isCorrect
                                      ? 'bg-emerald-600 text-white'
                                      : 'border border-slate-300 dark:border-slate-600 text-slate-500'
                                  }`}
                                >
                                  {isCorrect ? <Check size={12} /> : optionLetter}
                                </button>

                                {(viewMode === 'split' || viewMode === 'en') && (
                                  <input
                                    type="text"
                                    required
                                    value={quizFormData.optionsEn[oIdx] || ''}
                                    onChange={(e) => {
                                      const next = [...quizFormData.optionsEn];
                                      next[oIdx] = e.target.value;
                                      setQuizFormData({ ...quizFormData, optionsEn: next });
                                    }}
                                    placeholder={`Choice ${optionLetter} (English)...`}
                                    className="flex-1 px-3 py-1.5 text-xs bg-transparent text-slate-900 dark:text-white focus:outline-hidden"
                                  />
                                )}

                                {(viewMode === 'split' || viewMode === 'am') && (
                                  <input
                                    type="text"
                                    required
                                    value={quizFormData.optionsAm[oIdx] || ''}
                                    onChange={(e) => {
                                      const next = [...quizFormData.optionsAm];
                                      next[oIdx] = e.target.value;
                                      setQuizFormData({ ...quizFormData, optionsAm: next });
                                    }}
                                    placeholder={`አማራጭ ${optionLetter} (በአማርኛ)...`}
                                    className="flex-1 px-3 py-1.5 text-xs bg-transparent text-slate-900 dark:text-white focus:outline-hidden"
                                  />
                                )}

                                {isCorrect && (
                                  <span className="text-[10px] font-extrabold uppercase px-2 py-0.5 rounded-full bg-emerald-100 text-emerald-800 dark:bg-emerald-900 dark:text-emerald-200 shrink-0">
                                    Correct Answer
                                  </span>
                                )}
                              </div>
                            );
                          })}
                        </div>
                      </div>

                      {/* Explanation */}
                      <div className={`grid gap-4 pt-2 ${viewMode === 'split' ? 'grid-cols-1 md:grid-cols-2' : 'grid-cols-1'}`}>
                        {(viewMode === 'split' || viewMode === 'en') && (
                          <div>
                            <label className="block font-bold text-slate-700 dark:text-slate-300 text-xs mb-1">
                              Clinical Explanation (English) *
                            </label>
                            <textarea
                              rows={2}
                              required
                              value={quizFormData.explanationEn}
                              onChange={(e) =>
                                setQuizFormData({ ...quizFormData, explanationEn: e.target.value })
                              }
                              placeholder="Clinical explanation shown after student submits answer..."
                              className="w-full px-3 py-1.5 border border-slate-200 dark:border-slate-700 rounded-xl bg-white dark:bg-slate-850 text-slate-900 dark:text-white text-xs focus:border-amber-500 focus:outline-hidden"
                            />
                          </div>
                        )}

                        {(viewMode === 'split' || viewMode === 'am') && (
                          <div>
                            <label className="block font-bold text-slate-700 dark:text-slate-300 text-xs mb-1">
                              የህክምና ማብራሪያ (በአማርኛ) *
                            </label>
                            <textarea
                              rows={2}
                              required
                              value={quizFormData.explanationAm}
                              onChange={(e) =>
                                setQuizFormData({ ...quizFormData, explanationAm: e.target.value })
                              }
                              placeholder="ተማሪዎች ከመለሱ በኋላ የሚታይ የህክምና ማብራሪያ..."
                              className="w-full px-3 py-1.5 border border-slate-200 dark:border-slate-700 rounded-xl bg-white dark:bg-slate-850 text-slate-900 dark:text-white text-xs focus:border-amber-500 focus:outline-hidden"
                            />
                          </div>
                        )}
                      </div>

                      <div className="flex justify-end gap-2 pt-2">
                        <button
                          type="button"
                          onClick={() => setQuizFormOpen(false)}
                          className="px-4 py-2 border border-slate-200 dark:border-slate-700 rounded-xl text-xs font-bold text-slate-600 dark:text-slate-300 hover:bg-slate-100 cursor-pointer"
                        >
                          {lang === 'am' ? 'ሰርዝ' : 'Cancel'}
                        </button>
                        <button
                          type="submit"
                          className="px-5 py-2 bg-amber-600 hover:bg-amber-700 text-white rounded-xl text-xs font-extrabold cursor-pointer shadow-xs"
                        >
                          {lang === 'am' ? 'ጥያቄውን መዝግብ' : 'Save Question'}
                        </button>
                      </div>
                    </form>
                  )}

                  {/* List of Configured Questions */}
                  {moduleQuestions.length === 0 ? (
                    <div className="text-center py-12 border-2 border-dashed border-slate-200 dark:border-slate-800 rounded-2xl p-6 bg-white dark:bg-slate-900">
                      <HelpCircle size={32} className="mx-auto text-slate-300 dark:text-slate-600 mb-2" />
                      <p className="text-sm font-bold text-slate-700 dark:text-slate-300">
                        {lang === 'am' ? 'ለዚህ ሞጁል የተመዘገበ የፈተና ጥያቄ የለም' : 'No quiz questions created yet'}
                      </p>
                      <p className="text-xs text-slate-400 mt-1 max-w-sm mx-auto">
                        {lang === 'am'
                          ? 'የመጀመሪያውን የፈተና ጥያቄ ለመጨመር ከላይ ያለውን "ጥያቄ ጨምር" ቁልፍ ይጫኑ'
                          : 'Click "+ Add Question" above to author interactive knowledge-check questions for this module.'}
                      </p>
                    </div>
                  ) : (
                    <div className="space-y-4">
                      {moduleQuestions.map((q, qIdx) => (
                        <div
                          key={q.id || qIdx}
                          className="bg-white dark:bg-slate-900 border border-slate-200/80 dark:border-slate-800 rounded-2xl p-5 shadow-xs space-y-4"
                        >
                          <div className="flex items-center justify-between gap-3 border-b border-slate-100 dark:border-slate-800 pb-3">
                            <div className="flex items-center gap-2">
                              <span className="text-xs font-extrabold px-2.5 py-0.5 rounded-full bg-amber-50 dark:bg-amber-950/50 text-amber-800 dark:text-amber-400 border border-amber-200 dark:border-amber-900/40">
                                Question {qIdx + 1} of {moduleQuestions.length}
                              </span>
                              <span className="text-[11px] font-bold text-slate-400 uppercase">
                                • {q.type === 'TRUE_FALSE' ? 'True / False' : 'Multiple Choice'}
                              </span>
                            </div>

                            <div className="flex items-center gap-1.5">
                              <button
                                type="button"
                                onClick={() => openEditQuizQuestion(q, qIdx)}
                                className="p-1.5 text-slate-400 hover:text-amber-600 hover:bg-slate-50 dark:hover:bg-slate-800 rounded-lg cursor-pointer"
                                title="Edit Question"
                              >
                                <Edit2 size={14} />
                              </button>
                              <button
                                type="button"
                                onClick={() => handleDuplicateQuizQuestion(qIdx)}
                                className="p-1.5 text-slate-400 hover:text-slate-900 dark:hover:text-white hover:bg-slate-50 dark:hover:bg-slate-800 rounded-lg cursor-pointer"
                                title="Duplicate Question"
                              >
                                <Copy size={14} />
                              </button>
                              <button
                                type="button"
                                onClick={() => handleDeleteQuizQuestion(qIdx)}
                                className="p-1.5 text-slate-400 hover:text-rose-600 hover:bg-rose-50 dark:hover:bg-rose-950/40 rounded-lg cursor-pointer"
                                title="Delete Question"
                              >
                                <Trash2 size={14} />
                              </button>
                            </div>
                          </div>

                          <div>
                            <h5 className="font-extrabold text-slate-900 dark:text-white text-sm sm:text-base mb-1">
                              {q.questionEn}
                            </h5>
                            {q.questionAm && q.questionAm !== q.questionEn && (
                              <p className="text-xs text-slate-500 dark:text-slate-400 mb-2">
                                {q.questionAm}
                              </p>
                            )}
                          </div>

                          {/* Interactive Option Cards (1-Click Correct Selector) */}
                          <div className="grid grid-cols-1 sm:grid-cols-2 gap-2">
                            {q.optionsEn?.map((opt, oIdx) => {
                              const isCorrect = q.correctIndex === oIdx;
                              const optionLetter = String.fromCharCode(65 + oIdx);

                              return (
                                <button
                                  key={oIdx}
                                  type="button"
                                  onClick={() => handleSetCorrectAnswer(qIdx, oIdx)}
                                  className={`p-3 rounded-xl text-xs flex items-center justify-between text-left transition-all cursor-pointer ${
                                    isCorrect
                                      ? 'bg-emerald-50 dark:bg-emerald-950/40 text-emerald-900 dark:text-emerald-200 font-extrabold border-2 border-emerald-500 shadow-2xs'
                                      : 'bg-slate-50/70 dark:bg-slate-800/60 text-slate-700 dark:text-slate-300 font-medium border border-slate-200 dark:border-slate-700 hover:border-slate-300'
                                  }`}
                                  title="Click to mark as correct answer"
                                >
                                  <div className="flex items-center gap-2 min-w-0">
                                    <span className={`w-5 h-5 rounded-md flex items-center justify-center font-bold text-[10px] shrink-0 ${
                                      isCorrect
                                        ? 'bg-emerald-600 text-white'
                                        : 'bg-slate-200 dark:bg-slate-700 text-slate-600 dark:text-slate-400'
                                    }`}>
                                      {optionLetter}
                                    </span>
                                    <span className="truncate">{opt}</span>
                                  </div>

                                  {isCorrect && (
                                    <span className="text-[10px] font-extrabold uppercase px-2 py-0.5 rounded bg-emerald-100 text-emerald-800 dark:bg-emerald-900 dark:text-emerald-200 shrink-0">
                                      ✓ Correct
                                    </span>
                                  )}
                                </button>
                              );
                            })}
                          </div>

                          {/* Explanation Card */}
                          {q.explanationEn && (
                            <div className="p-3 rounded-xl bg-slate-100 dark:bg-slate-800/60 border border-slate-200 dark:border-slate-700 text-xs text-slate-700 dark:text-slate-300 flex items-start gap-2">
                              <Info size={14} className="text-slate-900 dark:text-white shrink-0 mt-0.5" />
                              <div>
                                <span className="font-bold text-slate-900 dark:text-white">Explanation: </span>
                                <span>{q.explanationEn}</span>
                              </div>
                            </div>
                          )}
                        </div>
                      ))}
                    </div>
                  )}

                  {/* Tab Navigation Actions */}
                  <div className="flex justify-between pt-2">
                    <button
                      type="button"
                      onClick={() => setModalTab('sections')}
                      className="px-4 py-2 border border-slate-200 dark:border-slate-700 rounded-xl text-xs font-bold text-slate-700 dark:text-slate-300 hover:bg-slate-50 cursor-pointer"
                    >
                      ← {lang === 'am' ? 'ተመለስ' : 'Back: Learning Sections'}
                    </button>
                    <button
                      type="button"
                      onClick={() => setModalTab('preview')}
                      className="px-5 py-2.5 bg-slate-950 hover:bg-slate-800 dark:bg-white dark:hover:bg-slate-100 text-white dark:text-slate-950 rounded-xl text-xs font-extrabold cursor-pointer transition-all flex items-center gap-1.5 border border-slate-900 dark:border-white shadow-xs active:scale-[0.99]"
                    >
                      <span>{lang === 'am' ? 'ቀጣይ፡ የሞባይል እይታ' : 'Next: Live Phone Simulator'}</span>
                      <Smartphone size={14} />
                    </button>
                  </div>
                </div>
              )}

              {/* ========================================================================= */}
              {/* TAB 5: LIVE PHONE PREVIEW SIMULATOR                                       */}
              {/* ========================================================================= */}
              {modalTab === 'preview' && (
                <div className="space-y-6">
                  <div className="flex items-center justify-between bg-white dark:bg-slate-900 p-4 rounded-2xl border border-slate-200/80 dark:border-slate-800 shadow-xs">
                    <div>
                      <h4 className="font-extrabold text-slate-900 dark:text-white text-sm">
                        {lang === 'am' ? 'ቀጥታ የሞባይል እይታ (Live iPhone Simulator)' : 'Live Mobile Phone Simulator'}
                      </h4>
                      <p className="text-xs text-slate-500 dark:text-slate-400">
                        {lang === 'am'
                          ? 'ተማሪዎች በሞባይል ስልካቸው ላይ የሚያዩትን ትክክለኛ ገጽታ በእውነተኛ ጊዜ ይመልከቱ'
                          : 'Real-time pixel-accurate preview replicating the exact mobile learner experience'}
                      </p>
                    </div>

                    <div className="flex items-center bg-slate-100 dark:bg-slate-800 p-0.5 rounded-xl border border-slate-200 dark:border-slate-700 text-xs font-bold">
                      <button
                        type="button"
                        onClick={() => setActiveLangTab('en')}
                        className={`px-3 py-1 rounded-lg transition-all cursor-pointer ${
                          activeLangTab === 'en'
                            ? 'bg-slate-950 dark:bg-white text-white dark:text-slate-950 shadow-xs'
                            : 'text-slate-600 dark:text-slate-400'
                        }`}
                      >
                        English
                      </button>
                      <button
                        type="button"
                        onClick={() => setActiveLangTab('am')}
                        className={`px-3 py-1 rounded-lg transition-all cursor-pointer ${
                          activeLangTab === 'am'
                            ? 'bg-slate-950 dark:bg-white text-white dark:text-slate-950 shadow-xs'
                            : 'text-slate-600 dark:text-slate-400'
                        }`}
                      >
                        አማርኛ
                      </button>
                    </div>
                  </div>

                  <div className="flex justify-center py-4">
                    <ModuleMobilePreview
                      title={activeLangTab === 'am' ? formData.titleAm : formData.titleEn}
                      summary={activeLangTab === 'am' ? formData.summaryAm : formData.summaryEn}
                      doctorNote={activeLangTab === 'am' ? formData.doctorNoteAm : formData.doctorNoteEn}
                      content={
                        sectionEditMode === 'form'
                          ? serializeSectionsToMarkdown(sections)[
                              activeLangTab === 'am' ? 'contentAm' : 'contentEn'
                            ]
                          : activeLangTab === 'am'
                          ? formData.contentAm
                          : formData.contentEn
                      }
                      imageUrl={formData.imageUrl}
                      authorName={formData.authorName}
                      readTimeMin={formData.readTimeMin}
                      category={formData.category}
                      lang={activeLangTab}
                      quizQuestionsCount={moduleQuestions.length}
                    />
                  </div>
                </div>
              )}
            </div>
          </main>

          {/* STUDIO BOTTOM ACTION FOOTER */}
          <footer className="px-5 sm:px-8 py-3.5 bg-white dark:bg-slate-900 border-t border-slate-200 dark:border-slate-800 flex items-center justify-between shrink-0 shadow-xs z-30">
            <span className="text-xs text-slate-500 font-semibold">
              {sections.length} {lang === 'am' ? 'ክፍሎች' : 'Sections'} • {moduleQuestions.length} {lang === 'am' ? 'ፈተና ጥያቄዎች' : 'Quiz Questions'}
            </span>

            <div className="flex items-center gap-2">
              <button
                type="button"
                onClick={() => setIsModalOpen(false)}
                className="px-4 py-2 border border-slate-200 dark:border-slate-700 rounded-xl text-xs font-bold text-slate-600 dark:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-800 cursor-pointer transition-all"
              >
                {lang === 'am' ? 'ሰርዝ' : 'Cancel'}
              </button>

              <button
                type="button"
                onClick={() => handleSubmit()}
                disabled={isSubmitting || !formData.titleEn.trim()}
                className="px-5 py-2 bg-slate-950 hover:bg-slate-800 dark:bg-white dark:hover:bg-slate-100 text-white dark:text-slate-950 rounded-xl text-xs font-extrabold transition-all border border-slate-900 dark:border-white shadow-xs flex items-center gap-1.5 cursor-pointer disabled:opacity-50 active:scale-[0.99]"
              >
                {isSubmitting ? (
                  <>
                    <div className="w-3.5 h-3.5 border-2 border-white border-t-transparent rounded-full animate-spin" />
                    <span>{lang === 'am' ? 'በመመዝገብ ላይ...' : 'Saving...'}</span>
                  </>
                ) : (
                  <>
                    <Save size={14} />
                    <span>
                      {editingModule
                        ? lang === 'am'
                          ? 'ለውጦችን መዝግብ'
                          : 'Save Changes'
                        : lang === 'am'
                        ? 'ሞጁሉን አትም'
                        : 'Publish Health Module'}
                    </span>
                  </>
                )}
              </button>
            </div>
          </footer>

          {/* Cover Illustration Chooser Modal */}
          {showImagePicker && (
            <div className="fixed inset-0 z-60 bg-slate-950/70 backdrop-blur-xs flex items-center justify-center p-4">
              <div className="bg-white dark:bg-slate-900 rounded-2xl border border-slate-200 dark:border-slate-800 shadow-2xl max-w-2xl w-full p-6 space-y-4 animate-in fade-in zoom-in-95">
                <div className="flex items-center justify-between pb-2 border-b border-slate-100 dark:border-slate-800">
                  <h4 className="font-extrabold text-sm text-slate-900 dark:text-white flex items-center gap-2">
                    <ImageIcon size={18} className="text-slate-900 dark:text-white" />
                    <span>{lang === 'am' ? 'የሞጁሉን ስዕል ምረጥ ወይም ስቀል' : 'Module Cover Image'}</span>
                  </h4>
                  <button
                    onClick={() => setShowImagePicker(false)}
                    className="p-1 text-slate-400 hover:text-slate-600 dark:hover:text-slate-200 cursor-pointer"
                  >
                    <X size={16} />
                  </button>
                </div>

                {/* 3 Source Tabs: Upload / Official / Custom URL */}
                <div className="flex items-center gap-1 bg-slate-100 dark:bg-slate-800 p-1 rounded-xl">
                  <button
                    type="button"
                    onClick={() => setImagePickerTab('upload')}
                    className={`flex-1 py-1.5 px-3 rounded-lg text-xs font-extrabold flex items-center justify-center gap-1.5 transition-all cursor-pointer ${
                      imagePickerTab === 'upload'
                        ? 'bg-white dark:bg-slate-900 text-slate-900 dark:text-white shadow-xs'
                        : 'text-slate-500 hover:text-slate-900 dark:hover:text-white'
                    }`}
                  >
                    <UploadCloud size={14} />
                    <span>{lang === 'am' ? 'ከኮምፒውተር ስቀል' : 'Upload Image'}</span>
                  </button>
                  <button
                    type="button"
                    onClick={() => setImagePickerTab('illustrations')}
                    className={`flex-1 py-1.5 px-3 rounded-lg text-xs font-extrabold flex items-center justify-center gap-1.5 transition-all cursor-pointer ${
                      imagePickerTab === 'illustrations'
                        ? 'bg-white dark:bg-slate-900 text-slate-900 dark:text-white shadow-xs'
                        : 'text-slate-500 hover:text-slate-900 dark:hover:text-white'
                    }`}
                  >
                    <ImageIcon size={14} />
                    <span>{lang === 'am' ? 'የተዘጋጁ ስዕሎች' : 'Official Illustrations'}</span>
                  </button>
                  <button
                    type="button"
                    onClick={() => setImagePickerTab('url')}
                    className={`flex-1 py-1.5 px-3 rounded-lg text-xs font-extrabold flex items-center justify-center gap-1.5 transition-all cursor-pointer ${
                      imagePickerTab === 'url'
                        ? 'bg-white dark:bg-slate-900 text-slate-900 dark:text-white shadow-xs'
                        : 'text-slate-500 hover:text-slate-900 dark:hover:text-white'
                    }`}
                  >
                    <LinkIcon size={14} />
                    <span>{lang === 'am' ? 'የስዕል ሊንክ' : 'Custom URL'}</span>
                  </button>
                </div>

                {/* TAB 1: UPLOAD FROM COMPUTER */}
                {imagePickerTab === 'upload' && (
                  <div className="space-y-4 py-2">
                    <label className="relative border-2 border-dashed border-slate-300 dark:border-slate-700 hover:border-[#0284C7] dark:hover:border-sky-500 rounded-2xl p-8 flex flex-col items-center justify-center gap-3 cursor-pointer bg-slate-50/50 dark:bg-slate-850/50 transition-all text-center group">
                      <input
                        type="file"
                        accept="image/jpeg,image/png,image/webp,image/svg+xml"
                        disabled={isCompressingImage}
                        onChange={handleImageFileUpload}
                        className="sr-only"
                      />
                      {isCompressingImage ? (
                        <div className="flex flex-col items-center gap-2 py-4">
                          <div className="w-8 h-8 border-3 border-[#0284C7] border-t-transparent rounded-full animate-spin" />
                          <p className="text-xs font-bold text-slate-600 dark:text-slate-300">
                            {lang === 'am' ? 'ስዕሉ እየተመጠነ ነው...' : 'Optimizing and compressing image...'}
                          </p>
                        </div>
                      ) : (
                        <>
                          <div className="w-12 h-12 rounded-2xl bg-sky-100 dark:bg-sky-950/70 text-[#0284C7] flex items-center justify-center group-hover:scale-105 transition-transform">
                            <UploadCloud size={24} />
                          </div>
                          <div>
                            <p className="font-extrabold text-sm text-slate-900 dark:text-white">
                              {lang === 'am' ? 'ስዕል ለመምረጥ እዚህ ይጫኑ ወይም ይጎትቱ' : 'Click to select or drag and drop an image'}
                            </p>
                            <p className="text-xs text-slate-400 mt-1">
                              Supports JPG, PNG, WebP • Auto-compressed to &lt; 80KB Base64 Data URI
                            </p>
                          </div>
                          <span className="text-[11px] font-semibold text-[#0284C7] bg-sky-50 dark:bg-sky-950 px-3 py-1 rounded-full border border-sky-200 dark:border-sky-800">
                            Stored directly in Database (Works 100% Offline)
                          </span>
                        </>
                      )}
                    </label>
                  </div>
                )}

                {/* TAB 2: OFFICIAL ILLUSTRATIONS */}
                {imagePickerTab === 'illustrations' && (
                  <div className="grid grid-cols-2 sm:grid-cols-4 gap-3 max-h-[60vh] overflow-y-auto p-1">
                    {OFFICIAL_ILLUSTRATIONS.map((ill) => {
                      const isSelected = formData.imageUrl === ill.path;
                      return (
                        <button
                          key={ill.id}
                          type="button"
                          onClick={() => {
                            setFormData({ ...formData, imageUrl: ill.path });
                            setShowImagePicker(false);
                          }}
                          className={`p-2.5 rounded-xl border text-center transition-all cursor-pointer flex flex-col items-center justify-between ${
                            isSelected
                              ? 'border-slate-900 dark:border-white bg-slate-100 dark:bg-slate-800 ring-2 ring-slate-900/10 dark:ring-white/20'
                              : 'border-slate-200 dark:border-slate-800 bg-slate-50 dark:bg-slate-850 hover:border-slate-300'
                          }`}
                        >
                          <div className="w-16 h-16 rounded-lg bg-white dark:bg-slate-800 p-1 flex items-center justify-center mb-2 overflow-hidden">
                            <img
                              src={ill.previewUrl}
                              alt=""
                              className="w-full h-full object-contain"
                            />
                          </div>
                          <span className="text-[11px] font-extrabold text-slate-800 dark:text-slate-200 line-clamp-1">
                            {ill.name}
                          </span>
                        </button>
                      );
                    })}
                  </div>
                )}

                {/* TAB 3: CUSTOM URL */}
                {imagePickerTab === 'url' && (
                  <div className="space-y-4 py-2">
                    <div>
                      <label className="block font-bold text-slate-700 dark:text-slate-300 text-xs mb-1.5">
                        {lang === 'am' ? 'የስዕል ዌብሳይት ሊንክ (Image URL)' : 'Web Image URL'}
                      </label>
                      <div className="flex gap-2">
                        <input
                          type="url"
                          value={customUrlInput}
                          onChange={(e) => setCustomUrlInput(e.target.value)}
                          placeholder="https://images.unsplash.com/photo-..."
                          className="flex-1 px-3.5 py-2 border border-slate-200 dark:border-slate-700 rounded-xl bg-slate-50 dark:bg-slate-850 text-slate-900 dark:text-white text-xs focus:border-slate-900 dark:focus:border-white focus:outline-hidden"
                        />
                        <button
                          type="button"
                          disabled={!customUrlInput.trim()}
                          onClick={handleApplyCustomUrl}
                          className="px-4 py-2 bg-slate-950 dark:bg-white text-white dark:text-slate-950 font-bold text-xs rounded-xl disabled:opacity-40 cursor-pointer"
                        >
                          {lang === 'am' ? 'ተግብር' : 'Apply'}
                        </button>
                      </div>
                    </div>
                    {customUrlInput.trim() && (
                      <div className="w-full h-40 rounded-xl border border-slate-200 dark:border-slate-700 overflow-hidden flex items-center justify-center bg-slate-100 dark:bg-slate-850 p-2">
                        <img
                          src={customUrlInput.trim()}
                          alt="Preview"
                          className="max-h-full max-w-full object-contain"
                          onError={(e) => {
                            (e.target as HTMLImageElement).style.display = 'none';
                          }}
                        />
                      </div>
                    )}
                  </div>
                )}
              </div>
            </div>
          )}
        </div>
      )}

      {/* Module Deletion Confirmation Modal */}
      {moduleToDelete && (
        <ConfirmModal
          isOpen={true}
          onClose={() => setModuleToDelete(null)}
          onConfirm={async () => {
            if (moduleToDelete) {
              await onDelete(moduleToDelete.id);
              setModuleToDelete(null);
            }
          }}
          title={lang === 'am' ? 'ሞጁሉን ሰርዝ' : 'Delete Curriculum Module'}
          message={
            lang === 'am'
              ? `እርግጠኛ ነዎት "${moduleToDelete.titleAm}" የሚለውን የትምህርት ሞጁል መሰረዝ ይፈልጋሉ? የተያያዙ የፈተና ጥያቄዎችና ምዘናዎች በሙሉ ይሰረዛሉ።`
              : `Are you sure you want to delete "${moduleToDelete.titleEn}"? All associated quiz questions and assessments will be permanently removed.`
          }
          confirmLabel={lang === 'am' ? 'ሰርዝ' : 'Delete Module'}
          cancelLabel={lang === 'am' ? 'አትሰርዝ' : 'Cancel'}
        />
      )}
    </div>
  );
};
