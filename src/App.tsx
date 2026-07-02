import { Routes, Route, useLocation } from "react-router-dom";
import { useEffect } from "react";
import Layout from "@/components/layout/Layout";
import Home from "@/pages/Home";
import About from "@/pages/About";
import Services from "@/pages/Services";
import ServiceDetail from "@/pages/ServiceDetail";
import SolutionsPage from "@/pages/Solutions";
import Documentation from "@/pages/Documentation";
import Blog from "@/pages/Blog";
import BlogPost from "@/pages/BlogPost";
import Appointment from "@/pages/Appointment";
import Coworking from "@/pages/Coworking";
import Surveys from "@/pages/Surveys";
import Contact from "@/pages/Contact";

function ScrollToTop() {
  const { pathname } = useLocation();
  useEffect(() => {
    window.scrollTo(0, 0);
  }, [pathname]);
  return null;
}

function App() {
  return (
    <>
      <ScrollToTop />
      <Layout>
        <Routes>
          <Route path="/" element={<Home />} />
          <Route path="/a-propos" element={<About />} />
          <Route path="/services" element={<Services />} />
          <Route path="/services/:slug" element={<ServiceDetail />} />
          <Route path="/solutions" element={<SolutionsPage />} />
          <Route path="/documentation" element={<Documentation />} />
          <Route path="/blog" element={<Blog />} />
          <Route path="/blog/:slug" element={<BlogPost />} />
          <Route path="/rendez-vous" element={<Appointment />} />
          <Route path="/co-working" element={<Coworking />} />
          <Route path="/sondages" element={<Surveys />} />
          <Route path="/contact" element={<Contact />} />
          <Route path="*" element={<Home />} />
        </Routes>
      </Layout>
    </>
  );
}

export default App;
