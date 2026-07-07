import { useState } from 'react';
import { useNavigate, Link } from 'react-router-dom';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';
import { useAuth } from '@/contexts/AuthContext';
import { Mail, Lock, User, Phone, AlertCircle, CheckCircle } from 'lucide-react';

const signupSchema = z.object({
  firstName: z.string().min(2, 'Minimum 2 caractères'),
  lastName: z.string().min(2, 'Minimum 2 caractères'),
  email: z.string().email('Email invalide'),
  phone: z.string().min(8, 'Minimum 8 caractères'),
  password: z.string().min(6, 'Minimum 6 caractères'),
  confirmPassword: z.string(),
}).refine((data) => data.password === data.confirmPassword, {
  message: "Les mots de passe ne correspondent pas",
  path: ["confirmPassword"],
});

type SignupData = z.infer<typeof signupSchema>;

export default function SignupForm() {
  const [error, setError] = useState('');
  const [success, setSuccess] = useState(false);
  const [loading, setLoading] = useState(false);
  const { signUp } = useAuth();
  const navigate = useNavigate();

  const {
    register,
    handleSubmit,
    formState: { errors },
  } = useForm<SignupData>({
    resolver: zodResolver(signupSchema),
  });

  const onSubmit = async (data: SignupData) => {
    try {
      setError('');
      setLoading(true);
      await signUp(data.email, data.password, {
        first_name: data.firstName,
        last_name: data.lastName,
        phone: data.phone,
      });
      setSuccess(true);
      setTimeout(() => navigate('/auth/connexion'), 3000);
    } catch (err: any) {
      setError(err.message || "Erreur lors de l'inscription");
    } finally {
      setLoading(false);
    }
  };

  if (success) {
    return (
      <div className="w-full max-w-md mx-auto">
        <div className="bg-white rounded-2xl shadow-card p-8 text-center">
          <CheckCircle className="w-16 h-16 text-emerald-500 mx-auto mb-4" />
          <h2 className="font-display text-2xl font-semibold text-dark mb-2">
            Inscription réussie !
          </h2>
          <p className="text-body mb-6">
            Vérifiez votre email pour confirmer votre compte.
          </p>
          <Link to="/auth/connexion" className="btn-primary inline-block">
            Se connecter
          </Link>
        </div>
      </div>
    );
  }

  return (
    <div className="w-full max-w-md mx-auto">
      <div className="bg-white rounded-2xl shadow-card p-8">
        <h2 className="font-display text-2xl font-semibold text-dark text-center mb-2">
          Créer un compte
        </h2>
        <p className="text-body text-sm text-center mb-8">
          Inscrivez-vous pour accéder à nos services
        </p>

        {error && (
          <div className="mb-6 p-4 bg-red-50 border border-red-200 rounded-lg flex items-start gap-3">
            <AlertCircle className="w-5 h-5 text-red-600 shrink-0 mt-0.5" />
            <p className="text-sm text-red-800">{error}</p>
          </div>
        )}

        <form onSubmit={handleSubmit(onSubmit)} className="space-y-5">
          <div className="grid sm:grid-cols-2 gap-5">
            <div>
              <label className="block text-sm font-medium text-dark mb-1.5">Prénom *</label>
              <div className="relative">
                <User className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-body" />
                <input
                  {...register('firstName')}
                  className={`w-full pl-10 pr-4 py-3 border rounded-lg text-sm focus:outline-none focus:border-primary focus:ring-2 focus:ring-primary/10 ${
                    errors.firstName ? 'border-red-500' : 'border-gray-200'
                  }`}
                />
              </div>
              {errors.firstName && <p className="text-red-500 text-xs mt-1">{errors.firstName.message}</p>}
            </div>

            <div>
              <label className="block text-sm font-medium text-dark mb-1.5">Nom *</label>
              <div className="relative">
                <User className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-body" />
                <input
                  {...register('lastName')}
                  className={`w-full pl-10 pr-4 py-3 border rounded-lg text-sm focus:outline-none focus:border-primary focus:ring-2 focus:ring-primary/10 ${
                    errors.lastName ? 'border-red-500' : 'border-gray-200'
                  }`}
                />
              </div>
              {errors.lastName && <p className="text-red-500 text-xs mt-1">{errors.lastName.message}</p>}
            </div>
          </div>

          <div>
            <label className="block text-sm font-medium text-dark mb-1.5">Email *</label>
            <div className="relative">
              <Mail className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-body" />
              <input
                type="email"
                {...register('email')}
                className={`w-full pl-10 pr-4 py-3 border rounded-lg text-sm focus:outline-none focus:border-primary focus:ring-2 focus:ring-primary/10 ${
                  errors.email ? 'border-red-500' : 'border-gray-200'
                }`}
              />
            </div>
            {errors.email && <p className="text-red-500 text-xs mt-1">{errors.email.message}</p>}
          </div>

          <div>
            <label className="block text-sm font-medium text-dark mb-1.5">Téléphone *</label>
            <div className="relative">
              <Phone className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-body" />
              <input
                type="tel"
                {...register('phone')}
                placeholder="+225 07 XX XX XX XX"
                className={`w-full pl-10 pr-4 py-3 border rounded-lg text-sm focus:outline-none focus:border-primary focus:ring-2 focus:ring-primary/10 ${
                  errors.phone ? 'border-red-500' : 'border-gray-200'
                }`}
              />
            </div>
            {errors.phone && <p className="text-red-500 text-xs mt-1">{errors.phone.message}</p>}
          </div>

          <div>
            <label className="block text-sm font-medium text-dark mb-1.5">Mot de passe *</label>
            <div className="relative">
              <Lock className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-body" />
              <input
                type="password"
                {...register('password')}
                className={`w-full pl-10 pr-4 py-3 border rounded-lg text-sm focus:outline-none focus:border-primary focus:ring-2 focus:ring-primary/10 ${
                  errors.password ? 'border-red-500' : 'border-gray-200'
                }`}
              />
            </div>
            {errors.password && <p className="text-red-500 text-xs mt-1">{errors.password.message}</p>}
          </div>

          <div>
            <label className="block text-sm font-medium text-dark mb-1.5">Confirmer le mot de passe *</label>
            <div className="relative">
              <Lock className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-body" />
              <input
                type="password"
                {...register('confirmPassword')}
                className={`w-full pl-10 pr-4 py-3 border rounded-lg text-sm focus:outline-none focus:border-primary focus:ring-2 focus:ring-primary/10 ${
                  errors.confirmPassword ? 'border-red-500' : 'border-gray-200'
                }`}
              />
            </div>
            {errors.confirmPassword && <p className="text-red-500 text-xs mt-1">{errors.confirmPassword.message}</p>}
          </div>

          <button
            type="submit"
            disabled={loading}
            className="btn-primary w-full disabled:opacity-60"
          >
            {loading ? 'Inscription...' : "S'inscrire"}
          </button>
        </form>

        <div className="mt-6 text-center text-sm text-body">
          Vous avez déjà un compte ?{' '}
          <Link to="/auth/connexion" className="text-primary font-medium hover:underline">
            Se connecter
          </Link>
        </div>
      </div>
    </div>
  );
}
