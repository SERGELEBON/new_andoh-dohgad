import { useState, useEffect } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { supabase } from '@/lib/supabase/client';
import AdminLayout from '@/components/layout/AdminLayout';
import ImageUpload from '@/components/admin/ImageUpload';
import { Save, ArrowLeft, Eye } from 'lucide-react';
import { useAuth } from '@/contexts/AuthContext';

interface BlogForm {
  title_fr: string;
  title_en: string;
  title_es: string;
  slug: string;
  category: string;
  excerpt_fr: string;
  excerpt_en: string;
  excerpt_es: string;
  content_fr: string;
  content_en: string;
  content_es: string;
  featured_image: string;
  published: boolean;
  tags: string[];
}

export default function BlogEditor() {
  const { id } = useParams();
  const navigate = useNavigate();
  const { profile } = useAuth();
  const [loading, setLoading] = useState(false);
  const [form, setForm] = useState<BlogForm>({
    title_fr: '',
    title_en: '',
    title_es: '',
    slug: '',
    category: 'actualites',
    excerpt_fr: '',
    excerpt_en: '',
    excerpt_es: '',
    content_fr: '',
    content_en: '',
    content_es: '',
    featured_image: '',
    published: false,
    tags: [],
  });

  useEffect(() => {
    if (id) {
      fetchPost();
    }
  }, [id]);

  const fetchPost = async () => {
    try {
      const { data, error } = await supabase
        .from('blog_posts')
        .select('*')
        .eq('id', id)
        .single();

      if (error) throw error;
      setForm(data);
    } catch (error) {
      console.error('Error fetching post:', error);
      alert('Erreur lors du chargement de l\'article');
    }
  };

  const generateSlug = (title: string) => {
    return title
      .toLowerCase()
      .normalize('NFD')
      .replace(/[̀-ͯ]/g, '')
      .replace(/[^a-z0-9]+/g, '-')
      .replace(/(^-|-$)/g, '');
  };

  const handleTitleChange = (value: string) => {
    setForm({
      ...form,
      title_fr: value,
      slug: generateSlug(value),
    });
  };

  const handleSave = async (publish: boolean = false) => {
    if (!form.title_fr || !form.content_fr) {
      alert('Le titre et le contenu français sont obligatoires');
      return;
    }

    setLoading(true);
    try {
      const postData = {
        ...form,
        published: publish,
        author_id: profile?.id,
        updated_at: new Date().toISOString(),
      };

      if (id) {
        // Update
        const { error } = await supabase
          .from('blog_posts')
          .update(postData)
          .eq('id', id);

        if (error) throw error;
        alert('Article mis à jour avec succès');
      } else {
        // Create
        const { error } = await supabase
          .from('blog_posts')
          .insert([{ ...postData, created_at: new Date().toISOString() }]);

        if (error) throw error;
        alert('Article créé avec succès');
        navigate('/admin/blog');
      }
    } catch (error) {
      console.error('Error saving post:', error);
      alert('Erreur lors de l\'enregistrement');
    } finally {
      setLoading(false);
    }
  };

  return (
    <AdminLayout>
      <div className="p-6 lg:p-8">
        {/* Header */}
        <div className="mb-8 flex items-center justify-between">
          <div className="flex items-center gap-4">
            <button
              onClick={() => navigate('/admin/blog')}
              className="p-2 hover:bg-gray-100 rounded-lg transition-colors"
            >
              <ArrowLeft className="w-5 h-5" />
            </button>
            <div>
              <h1 className="text-2xl font-bold text-dark">
                {id ? 'Éditer l\'article' : 'Nouvel article'}
              </h1>
              <p className="text-gray-600">
                {form.slug && `/${form.slug}`}
              </p>
            </div>
          </div>

          <div className="flex items-center gap-3">
            <button
              onClick={() => handleSave(false)}
              disabled={loading}
              className="px-4 py-2 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-colors disabled:opacity-50"
            >
              <Save className="w-4 h-4 inline mr-2" />
              Enregistrer brouillon
            </button>
            <button
              onClick={() => handleSave(true)}
              disabled={loading}
              className="px-4 py-2 bg-primary text-white rounded-lg hover:bg-primary/90 transition-colors disabled:opacity-50"
            >
              <Eye className="w-4 h-4 inline mr-2" />
              Publier
            </button>
          </div>
        </div>

        <div className="grid lg:grid-cols-3 gap-6">
          {/* Main Content */}
          <div className="lg:col-span-2 space-y-6">
            {/* Français */}
            <div className="bg-white rounded-xl shadow-sm p-6 border border-gray-100">
              <h2 className="text-lg font-semibold text-dark mb-4">🇫🇷 Français</h2>

              <div className="space-y-4">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Titre *
                  </label>
                  <input
                    type="text"
                    value={form.title_fr}
                    onChange={(e) => handleTitleChange(e.target.value)}
                    className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent"
                    placeholder="Titre de l'article"
                  />
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Extrait
                  </label>
                  <textarea
                    value={form.excerpt_fr}
                    onChange={(e) => setForm({ ...form, excerpt_fr: e.target.value })}
                    rows={3}
                    className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent"
                    placeholder="Résumé court de l'article"
                  />
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Contenu *
                  </label>
                  <textarea
                    value={form.content_fr}
                    onChange={(e) => setForm({ ...form, content_fr: e.target.value })}
                    rows={15}
                    className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent font-mono text-sm"
                    placeholder="Contenu de l'article (Markdown supporté)"
                  />
                </div>
              </div>
            </div>

            {/* Anglais */}
            <div className="bg-white rounded-xl shadow-sm p-6 border border-gray-100">
              <h2 className="text-lg font-semibold text-dark mb-4">🇬🇧 English</h2>

              <div className="space-y-4">
                <input
                  type="text"
                  value={form.title_en}
                  onChange={(e) => setForm({ ...form, title_en: e.target.value })}
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg"
                  placeholder="Title"
                />
                <textarea
                  value={form.excerpt_en}
                  onChange={(e) => setForm({ ...form, excerpt_en: e.target.value })}
                  rows={3}
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg"
                  placeholder="Excerpt"
                />
                <textarea
                  value={form.content_en}
                  onChange={(e) => setForm({ ...form, content_en: e.target.value })}
                  rows={10}
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg font-mono text-sm"
                  placeholder="Content"
                />
              </div>
            </div>

            {/* Espagnol */}
            <div className="bg-white rounded-xl shadow-sm p-6 border border-gray-100">
              <h2 className="text-lg font-semibold text-dark mb-4">🇪🇸 Español</h2>

              <div className="space-y-4">
                <input
                  type="text"
                  value={form.title_es}
                  onChange={(e) => setForm({ ...form, title_es: e.target.value })}
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg"
                  placeholder="Título"
                />
                <textarea
                  value={form.excerpt_es}
                  onChange={(e) => setForm({ ...form, excerpt_es: e.target.value })}
                  rows={3}
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg"
                  placeholder="Extracto"
                />
                <textarea
                  value={form.content_es}
                  onChange={(e) => setForm({ ...form, content_es: e.target.value })}
                  rows={10}
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg font-mono text-sm"
                  placeholder="Contenido"
                />
              </div>
            </div>
          </div>

          {/* Sidebar */}
          <div className="space-y-6">
            {/* Paramètres */}
            <div className="bg-white rounded-xl shadow-sm p-6 border border-gray-100">
              <h3 className="font-semibold text-dark mb-4">Paramètres</h3>

              <div className="space-y-4">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Slug
                  </label>
                  <input
                    type="text"
                    value={form.slug}
                    onChange={(e) => setForm({ ...form, slug: e.target.value })}
                    className="w-full px-3 py-2 text-sm border border-gray-300 rounded-lg"
                  />
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Catégorie
                  </label>
                  <select
                    value={form.category}
                    onChange={(e) => setForm({ ...form, category: e.target.value })}
                    className="w-full px-3 py-2 text-sm border border-gray-300 rounded-lg"
                  >
                    <option value="actualites">Actualités</option>
                    <option value="conseils">Conseils</option>
                    <option value="etudes-cas">Études de cas</option>
                    <option value="guides">Guides</option>
                  </select>
                </div>

                <div>
                  <label className="flex items-center gap-2 cursor-pointer">
                    <input
                      type="checkbox"
                      checked={form.published}
                      onChange={(e) => setForm({ ...form, published: e.target.checked })}
                      className="w-4 h-4 text-primary border-gray-300 rounded focus:ring-primary"
                    />
                    <span className="text-sm font-medium text-gray-700">
                      Publié
                    </span>
                  </label>
                </div>
              </div>
            </div>

            {/* Image */}
            <div className="bg-white rounded-xl shadow-sm p-6 border border-gray-100">
              <h3 className="font-semibold text-dark mb-4">Image à la une</h3>

              <ImageUpload
                currentImageUrl={form.featured_image}
                onImageUploaded={(url) => setForm({ ...form, featured_image: url })}
                bucket="blog-images"
                maxSizeMB={5}
              />

              {/* URL manuelle (optionnel) */}
              <div className="mt-4 pt-4 border-t border-gray-200">
                <label className="block text-xs text-gray-600 mb-2">
                  Ou coller une URL d'image :
                </label>
                <input
                  type="text"
                  value={form.featured_image}
                  onChange={(e) => setForm({ ...form, featured_image: e.target.value })}
                  className="w-full px-3 py-2 text-sm border border-gray-300 rounded-lg"
                  placeholder="https://..."
                />
              </div>
            </div>
          </div>
        </div>
      </div>
    </AdminLayout>
  );
}
