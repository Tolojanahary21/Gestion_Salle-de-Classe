<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>

<html lang="fr">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Dashboard — Gestion des Salles de Classe</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/sidebar.css">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/dashboard.css">

</head>


<body>


<%@ include file="layouts/sidebar.jsp" %>


<main class="main-content">
    <header class="dashboard-header">

        <div>

            <h1>Dashboard</h1>

            <p>
                Vue d'ensemble de la gestion des salles de classe
            </p>

        </div>


        <div class="header-date">

            <i data-lucide="calendar"></i>

            <span>
                ${dateAffichee}
            </span>

        </div>

    </header>



    <%--CARTES STATISTIQUES --%>

    <section class="stats-grid">


        <%-- PROFESSEURS --%>

        <div class="stat-card">

            <div class="stat-card-info">

                <span class="stat-card-label">
                    Professeurs
                </span>

                <span class="stat-card-value">
                    ${totalProfesseurs}
                </span>

                <span class="stat-card-desc">
                    Professeurs enregistrés
                </span>

            </div>


            <div class="stat-card-icon">

                <i data-lucide="graduation-cap"></i>

            </div>

        </div>



        <%-- SALLES --%>

        <div class="stat-card">

            <div class="stat-card-info">

                <span class="stat-card-label">
                    Salles
                </span>

                <span class="stat-card-value">
                    ${totalSalles}
                </span>

                <span class="stat-card-desc">
                    Salles enregistrées
                </span>

            </div>


            <div class="stat-card-icon">

                <i data-lucide="building-2"></i>

            </div>

        </div>



        <%-- OCCUPATIONS --%>

        <div class="stat-card">

            <div class="stat-card-info">

                <span class="stat-card-label">
                    Occupations
                </span>

                <span class="stat-card-value">
                    ${totalOccupations}
                </span>

                <span class="stat-card-desc">
                    Occupations enregistrées
                </span>

            </div>


            <div class="stat-card-icon">

                <i data-lucide="calendar-days"></i>

            </div>

        </div>



        <%-- SALLES OCCUPEES --%>

        <div class="stat-card">

            <div class="stat-card-info">

                <span class="stat-card-label">
                    Salles occupées
                </span>

                <span class="stat-card-value">
                    ${sallesOccupees}
                </span>

                <span class="stat-card-desc">
                    Occupées aujourd'hui
                </span>

            </div>


            <div class="stat-card-icon">

                <i data-lucide="door-open"></i>

            </div>

        </div>


    </section>



    <%-- =====================================================
         OCCUPATIONS RECENTES + ETAT DES SALLES
    ====================================================== --%>

    <section class="content-grid">


        <%-- =================================================
             OCCUPATIONS RECENTES
        ================================================== --%>

        <div class="panel">


            <div class="panel-header">

                <div>

                    <h2>
                        Occupations récentes
                    </h2>

                    <div class="panel-subtitle">
                        Dernières occupations enregistrées
                    </div>

                </div>


                <i data-lucide="calendar-days"
                   style="width:18px;height:18px;color:#9ca3af;">
                </i>

            </div>



            <div class="panel-body">


                <table class="data-table">


                    <thead>

                    <tr>

                        <th>
                            Professeur
                        </th>

                        <th>
                            Salle
                        </th>

                        <th>
                            Date
                        </th>

                        <th>
                            Statut
                        </th>

                    </tr>

                    </thead>



                    <tbody>


                    <%-- Si aucune occupation --%>

                    <%
                        java.util.List<java.util.Map<String, Object>>
                                occupationsRecentes =
                                (java.util.List<java.util.Map<String, Object>>)
                                        request.getAttribute(
                                                "occupationsRecentes"
                                        );

                        if (occupationsRecentes == null
                                || occupationsRecentes.isEmpty()) {
                    %>

                    <tr>

                        <td colspan="4"
                            style="text-align:center;padding:30px;color:#9ca3af;">

                            Aucune occupation enregistrée.

                        </td>

                    </tr>

                    <%
                        } else {

                            for (
                                java.util.Map<String, Object> occupation
                                : occupationsRecentes
                            ) {
                    %>


                    <tr>


                        <td class="cell-primary">

                            <%= occupation.get("professeur") %>

                        </td>


                        <td>

                            <%= occupation.get("salle") %>

                        </td>


                        <td>

                            <%= occupation.get("date") %>

                        </td>


                        <td>


                            <%
                                String statut =
                                        String.valueOf(
                                                occupation.get("statut")
                                        );

                                String badgeClass;

                                if ("Occupée".equals(statut)) {

                                    badgeClass =
                                            "badge badge-occupee";

                                } else if ("Planifiée".equals(statut)) {

                                    badgeClass =
                                            "badge badge-planifiee";

                                } else {

                                    badgeClass =
                                            "badge badge-terminee";
                                }
                            %>


                            <span class="<%= badgeClass %>">

                                <%= statut %>

                            </span>


                        </td>


                    </tr>


                    <%
                            }
                        }
                    %>


                    </tbody>

                </table>


            </div>

        </div>



        <%-- =================================================
             ETAT DES SALLES
        ================================================== --%>

        <div class="panel">


            <div class="panel-header">

                <div>

                    <h2>
                        État des salles
                    </h2>

                    <div class="panel-subtitle">
                        Disponibilité pour aujourd'hui
                    </div>

                </div>


                <i data-lucide="door-open"
                   style="width:18px;height:18px;color:#9ca3af;">
                </i>

            </div>



            <div class="panel-body">


                <div class="room-list">


                    <%
                        java.util.List<java.util.Map<String, Object>>
                                etatSalles =
                                (java.util.List<java.util.Map<String, Object>>)
                                        request.getAttribute(
                                                "etatSalles"
                                        );

                        if (etatSalles == null
                                || etatSalles.isEmpty()) {
                    %>


                    <div style="
                        text-align:center;
                        padding:30px;
                        color:#9ca3af;
                    ">

                        Aucune salle enregistrée.

                    </div>


                    <%
                        } else {

                            for (
                                java.util.Map<String, Object> salle
                                : etatSalles
                            ) {

                                boolean occupee =
                                        Boolean.TRUE.equals(
                                                salle.get("occupee")
                                        );

                                String statut =
                                        String.valueOf(
                                                salle.get("statut")
                                        );
                    %>


                    <div class="room-row">


                        <span class="room-name">


                            <span class="
                                room-dot
                                <%= occupee
                                        ? "is-occupee"
                                        : "is-disponible" %>
                            ">
                            </span>


                            <%= salle.get("designation") %>


                        </span>



                        <span class="
                            room-status
                            <%= occupee
                                    ? "is-occupee"
                                    : "is-disponible" %>
                        ">

                            <%= statut %>

                        </span>


                    </div>


                    <%
                            }
                        }
                    %>


                </div>


            </div>

        </div>


    </section>



    <%-- =====================================================
         RESUME DES DISPONIBILITES
    ====================================================== --%>

    <section class="panel">


        <div class="panel-header">

            <div>

                <h2>
                    Disponibilité des salles
                </h2>

                <div class="panel-subtitle">
                    Situation actuelle basée sur les occupations du jour
                </div>

            </div>


            <i data-lucide="chart-no-axes-column"
               style="width:18px;height:18px;color:#9ca3af;">
            </i>

        </div>



        <div class="panel-body">


            <div class="quick-actions">


                <div class="quick-action-btn">

                    <span class="quick-action-icon">

                        <i data-lucide="door-open"></i>

                    </span>

                    <span>
                        ${sallesDisponibles}
                        salle(s) disponible(s)
                    </span>

                </div>



                <div class="quick-action-btn">

                    <span class="quick-action-icon">

                        <i data-lucide="door-closed"></i>

                    </span>

                    <span>
                        ${sallesOccupees}
                        salle(s) occupée(s)
                    </span>

                </div>


            </div>


        </div>


    </section>



    <%-- =====================================================
         ACTIONS RAPIDES
    ====================================================== --%>

    <section class="panel">


        <div class="panel-header">

            <div>

                <h2>
                    Actions rapides
                </h2>

                <div class="panel-subtitle">
                    Accès direct aux opérations courantes
                </div>

            </div>

        </div>



        <div class="panel-body"
             style="padding:18px 20px;">


            <div class="quick-actions">


                <button type="button"
                        class="quick-action-btn">

                    <span class="quick-action-icon">

                        <i data-lucide="user-plus"></i>

                    </span>

                    Ajouter un professeur

                </button>



                <button type="button"
                        class="quick-action-btn">

                    <span class="quick-action-icon">

                        <i data-lucide="building-2"></i>

                    </span>

                    Ajouter une salle

                </button>



                <button type="button"
                        class="quick-action-btn">

                    <span class="quick-action-icon">

                        <i data-lucide="calendar-plus"></i>

                    </span>

                    Nouvelle occupation

                </button>


            </div>


        </div>


    </section>


</main>



<script src="https://unpkg.com/lucide@latest/dist/umd/lucide.js">
</script>


<script>

    lucide.createIcons();

</script>


</body>

</html>