<%-- ==========================================================
     sidebar.jsp
     Fragment existant (fourni ici uniquement pour que l'apercu
     du Dashboard soit autonome). Ne pas modifier la structure
     reelle de ce fichier dans le projet.
========================================================== --%>
<aside class="sidebar">

    <div class="sidebar-header">
        <div class="logo-icon">
            <i data-lucide="layout-grid"></i>
        </div>
        <div class="logo-text">
            <strong>ClassRoom</strong>
            <span>Gestion des salles</span>
        </div>
    </div>

    <nav class="sidebar-nav">
        <a href="${pageContext.request.contextPath}/dashboard" class="nav-item active">
            <i data-lucide="layout-dashboard"></i>
            Dashboard
        </a>
        <a href="${pageContext.request.contextPath}/professeurs" class="nav-item">
            <i data-lucide="graduation-cap"></i>
            Professeurs
        </a>
        <a href="${pageContext.request.contextPath}/salles" class="nav-item">
            <i data-lucide="building-2"></i>
            Salles
        </a>
        <a href="${pageContext.request.contextPath}/occupations" class="nav-item">
            <i data-lucide="calendar-days"></i>
            Occupations
        </a>
    </nav>

</aside>
