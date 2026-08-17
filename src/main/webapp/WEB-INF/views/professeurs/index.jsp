<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>

<html lang="fr">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Professeurs — Gestion des Salles</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/sidebar.css">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/professeur.css">

</head>


<body>


<%@ include file="../layouts/sidebar.jsp" %>


<main class="main-content">


    <!-- HEADER -->

    <header class="page-header">

        <div>

            <h1>Professeurs</h1>

            <p>
                Gestion des professeurs de l'établissement
            </p>

        </div>


        <a href="${pageContext.request.contextPath}/professeurs/create"
           class="btn-primary">

            <i data-lucide="user-plus"></i>

            Ajouter un professeur

        </a>

    </header>



    <!-- RECHERCHE -->

    <section class="search-panel">

        <div class="search-box">

            <i data-lucide="search"></i>

            <input
                type="text"
                id="searchInput"
                placeholder="Rechercher par code ou nom..."
                autocomplete="off"
            >

        </div>

    </section>



    <!-- TABLE -->

    <section class="panel">


        <div class="panel-header">

            <div>

                <h2>
                    Liste des professeurs
                </h2>

                <div class="panel-subtitle">

                    <c:choose>

                        <c:when test="${empty professeurs}">
                            Aucun professeur enregistré
                        </c:when>

                        <c:otherwise>
                            ${professeurs.size()} professeur(s)
                        </c:otherwise>

                    </c:choose>

                </div>

            </div>


            <i data-lucide="graduation-cap"
               class="panel-icon">
            </i>

        </div>



        <div class="panel-body">


            <div class="table-container">


                <table class="data-table"
                       id="professeurTable">


                    <thead>

                    <tr>

                        <th>
                            Code
                        </th>

                        <th>
                            Nom
                        </th>

                        <th>
                            Prénom
                        </th>

                        <th>
                            Grade
                        </th>

                        <th class="actions-column">
                            Actions
                        </th>

                    </tr>

                    </thead>



                    <tbody>


                    <c:choose>


                        <c:when test="${empty professeurs}">


                            <tr>

                                <td colspan="5"
                                    class="empty-state">

                                    <div class="empty-icon">

                                        <i data-lucide="users-round"></i>

                                    </div>

                                    <strong>
                                        Aucun professeur
                                    </strong>

                                    <span>
                                        Aucun professeur n'est actuellement enregistré.
                                    </span>

                                </td>

                            </tr>


                        </c:when>



                        <c:otherwise>


                            <c:forEach
                                    var="prof"
                                    items="${professeurs}">


                                <tr class="professeur-row">


                                    <!-- CODE -->

                                    <td>

                                        <span class="code-badge">

                                            ${prof.codeProf}

                                        </span>

                                    </td>


                                    <!-- NOM -->

                                    <td class="cell-primary">

                                        ${prof.nom}

                                    </td>


                                    <!-- PRENOM -->

                                    <td>

                                        ${prof.prenom}

                                    </td>


                                    <!-- GRADE -->

                                    <td>

                                        <span class="grade-badge">

                                            ${prof.grade}

                                        </span>

                                    </td>


                                    <!-- ACTIONS -->

                                    <td class="actions">


                                        <!-- DETAILS -->

                                        <a
                                            href="${pageContext.request.contextPath}/professeurs/detail/${prof.codeProf}"
                                            class="action-btn view"
                                            title="Voir les détails">

                                            <i data-lucide="eye"></i>

                                        </a>


                                        <!-- UPDATE -->

                                        <a
                                            href="${pageContext.request.contextPath}/professeurs/update/${prof.codeProf}"
                                            class="action-btn edit"
                                            title="Modifier">

                                            <i data-lucide="pencil"></i>

                                        </a>


                                        <!-- DELETE -->

                                        <button
                                            type="button"
                                            class="action-btn delete"
                                            title="Supprimer"
                                            onclick="deleteProf('${prof.codeProf}')">

                                            <i data-lucide="trash-2"></i>

                                        </button>


                                    </td>


                                </tr>


                            </c:forEach>


                        </c:otherwise>


                    </c:choose>


                    </tbody>


                </table>


            </div>


        </div>


    </section>


</main>



<!-- LUCIDE -->

<script src="https://unpkg.com/lucide@latest/dist/umd/lucide.js">
</script>


<script>

    lucide.createIcons();


    /*
     * Recherche côté interface.
     *
     * La recherche fonctionne actuellement
     * sur le code et le nom du professeur.
     */

    const searchInput =
        document.getElementById("searchInput");

    const rows =
        document.querySelectorAll(".professeur-row");


    searchInput.addEventListener("input", function () {

        const search =
            this.value.toLowerCase().trim();


        rows.forEach(function (row) {

            const text =
                row.textContent.toLowerCase();


            row.style.display =
                text.includes(search)
                    ? ""
                    : "none";

        });

    });


    /*
     * Suppression.
     *
     * On ne branche pas encore la suppression
     * tant que nous n'avons pas créé la confirmation
     * et la route MVC correspondante.
     */

    function deleteProf(codeProf) {

        if (
            confirm(
                "Voulez-vous vraiment supprimer le professeur " +
                codeProf +
                " ?"
            )
        ) {

            /*
             * Cette partie sera connectée
             * à ton API REST /api/profs/{codeProf}
             * dans l'étape suppression.
             */

            console.log(
                "Suppression demandée :",
                codeProf
            );
        }

    }

</script>


</body>

</html>