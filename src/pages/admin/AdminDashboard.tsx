import { useEffect, useState } from 'react';
import { useAuth } from '@/contexts/AuthContext';
import { supabase } from '@/lib/supabase/client';
import AdminLayout from '@/components/layout/AdminLayout';
import { Users, Calendar, FileText, MessageSquare, DollarSign, TrendingUp } from 'lucide-react';

interface Stats {
  totalUsers: number;
  pendingAppointments: number;
  newSurveys: number;
  newMessages: number;
  monthlyRevenue: number;
  activeSubscriptions: number;
}

export default function AdminDashboard() {
  const { profile } = useAuth();
  const [stats, setStats] = useState<Stats>({
    totalUsers: 0,
    pendingAppointments: 0,
    newSurveys: 0,
    newMessages: 0,
    monthlyRevenue: 0,
    activeSubscriptions: 0,
  });
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchStats();
  }, []);

  const fetchStats = async () => {
    try {
      const startOfMonth = new Date();
      startOfMonth.setDate(1);
      startOfMonth.setHours(0, 0, 0, 0);

      const [
        { count: usersCount },
        { count: appointmentsCount },
        { count: surveysCount },
        { count: messagesCount },
        { data: purchases },
        { count: subsCount }
      ] = await Promise.all([
        supabase.from('profiles').select('*', { count: 'exact', head: true }),
        supabase.from('appointments').select('*', { count: 'exact', head: true }).eq('status', 'pending'),
        supabase.from('surveys').select('*', { count: 'exact', head: true }).eq('status', 'new'),
        supabase.from('contact_messages').select('*', { count: 'exact', head: true }).eq('status', 'new'),
        supabase.from('documentation_purchases').select('amount_paid').eq('payment_status', 'completed').gte('created_at', startOfMonth.toISOString()),
        supabase.from('coworking_subscriptions').select('*', { count: 'exact', head: true }).eq('status', 'active')
      ]);

      const revenue = purchases?.reduce((sum, p) => sum + parseFloat(p.amount_paid), 0) || 0;

      setStats({
        totalUsers: usersCount || 0,
        pendingAppointments: appointmentsCount || 0,
        newSurveys: surveysCount || 0,
        newMessages: messagesCount || 0,
        monthlyRevenue: revenue,
        activeSubscriptions: subsCount || 0,
      });
    } catch (error) {
      console.error('Error fetching stats:', error);
    } finally {
      setLoading(false);
    }
  };

  if (loading) {
    return (
      <AdminLayout>
        <div className="flex items-center justify-center h-screen">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary"></div>
        </div>
      </AdminLayout>
    );
  }

  return (
    <AdminLayout>
      <div className="p-6 lg:p-8">
        {/* Header */}
        <div className="mb-8">
          <h1 className="text-2xl font-bold text-dark mb-2">Dashboard</h1>
          <p className="text-gray-600">Bienvenue {profile?.first_name}, voici un aperçu de votre activité</p>
        </div>

        {/* Stats Grid */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          <StatCard
            icon={<Users className="w-6 h-6" />}
            label="Utilisateurs total"
            value={stats.totalUsers}
            color="blue"
          />
          <StatCard
            icon={<Calendar className="w-6 h-6" />}
            label="RDV en attente"
            value={stats.pendingAppointments}
            color="amber"
          />
          <StatCard
            icon={<FileText className="w-6 h-6" />}
            label="Sondages non traités"
            value={stats.newSurveys}
            color="purple"
          />
          <StatCard
            icon={<MessageSquare className="w-6 h-6" />}
            label="Messages non lus"
            value={stats.newMessages}
            color="green"
          />
          <StatCard
            icon={<DollarSign className="w-6 h-6" />}
            label="Revenus du mois"
            value={`${stats.monthlyRevenue.toLocaleString()} F`}
            color="emerald"
          />
          <StatCard
            icon={<TrendingUp className="w-6 h-6" />}
            label="Abonnements actifs"
            value={stats.activeSubscriptions}
            color="cyan"
          />
        </div>
      </div>
    </AdminLayout>
  );
}

interface StatCardProps {
  icon: React.ReactNode;
  label: string;
  value: number | string;
  color: string;
}

function StatCard({ icon, label, value, color }: StatCardProps) {
  const colorClasses = {
    blue: 'bg-blue-100 text-blue-600',
    amber: 'bg-amber-100 text-amber-600',
    purple: 'bg-purple-100 text-purple-600',
    green: 'bg-green-100 text-green-600',
    emerald: 'bg-emerald-100 text-emerald-600',
    cyan: 'bg-cyan-100 text-cyan-600',
  };

  return (
    <div className="bg-white rounded-xl shadow-sm p-6 border border-gray-100 hover:shadow-md transition-shadow">
      <div className="flex items-center justify-between mb-4">
        <div className={`w-12 h-12 rounded-lg flex items-center justify-center ${colorClasses[color as keyof typeof colorClasses]}`}>
          {icon}
        </div>
        <span className="text-2xl font-bold text-dark">{value}</span>
      </div>
      <h3 className="font-medium text-dark text-sm">{label}</h3>
    </div>
  );
}
