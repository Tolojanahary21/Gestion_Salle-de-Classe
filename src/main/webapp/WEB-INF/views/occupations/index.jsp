<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link rel="stylesheet"
        href="${pageContext.request.contextPath}/css/sidebar.css">
    <link rel="stylesheet"
        href="${pageContext.request.contextPath}/css/dashboard.css">
        <link rel="stylesheet"
        href="${pageContext.request.contextPath}/css/occupation.css">
    <title>Occupation</title>

   
</head>
<body>
    <%@ include file="../layouts/sidebar.jsp" %>

    <main class="main-content">

        <div class="page-header">
            <div>
                <h1>Occupations</h1>
                <p>Gestion des occupations de salles par les professeurs</p>
            </div>

            <button type="button" class="btn btn-primary" id="btnOpenCreate">
                <i data-lucide="calendar-plus"></i>
                Nouvelle occupation
            </button>
        </div>

        <section class="panel">
            <div class="panel-header">
                <div>
                    <h2>Liste des occupations</h2>
                    <div class="panel-subtitle">Toutes les occupations enregistrées dans le système</div>
                </div>
                <i data-lucide="calendar-days" style="width:18px;height:18px;color:#9ca3af;"></i>
            </div>

            <div class="panel-body">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Professeur</th>
                            <th>Salle</th>
                            <th>Date</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody id="tableOccupations">
                        <c:choose>
                            <c:when test="${empty occupations}">
                                <tr class="empty-row">
                                    <td colspan="4">Aucune occupation enregistrée.</td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="occupation" items="${occupations}">
                                    <tr data-code-prof="${occupation.codeProf}"
                                        data-code-salle="${occupation.codeSalle}"
                                        data-date="${occupation.date}">
                                        <td class="cell-primary">${occupation.codeProf}</td>
                                        <td>${occupation.codeSalle}</td>
                                        <td>${occupation.date}</td>
                                        <td>
                                            <div class="actions-cell">
                                                <button type="button"
                                                        class="btn-icon btn-edit"
                                                        title="Modifier"
                                                        data-code-prof="${occupation.codeProf}"
                                                        data-code-salle="${occupation.codeSalle}"
                                                        data-date="${occupation.date}"
                                                        onclick="ouvrirModalModification(this)">
                                                    <i data-lucide="pencil"></i>
                                                </button>
                                                <button type="button"
                                                        class="btn-icon btn-delete"
                                                        title="Supprimer"
                                                        data-code-prof="${occupation.codeProf}"
                                                        data-code-salle="${occupation.codeSalle}"
                                                        data-date="${occupation.date}"
                                                        onclick="supprimerOccupation('${occupation.codeProf}', '${occupation.codeSalle}', '${occupation.date}')">
                                                    <i data-lucide="trash-2"></i>
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </section>

    </main>

    <%-- ===== MODAL AJOUT / MODIFICATION ===== --%>
    <div class="modal-overlay" id="modalOccupation">
        <div class="modal-box">
            <div class="modal-header">
                <h2 id="modalTitle">Nouvelle occupation</h2>
                <button type="button" class="modal-close" onclick="fermerModal()">
                    <i data-lucide="x"></i>
                </button>
            </div>

            <form id="formOccupation">
                <div class="modal-body">
                    <div class="form-error" id="formError"></div>

                    <div class="form-group">
                        <label for="codeProf">Professeur</label>
                        <select id="codeProf" name="codeProf" required>
                            <option value="">-- Sélectionner un professeur --</option>
                            <c:forEach var="prof" items="${professeurs}">
                                <option value="${prof.codeProf}">
                                    ${prof.codeProf} - ${prof.nom} ${prof.prenom}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="codeSalle">Salle</label>
                        <select id="codeSalle" name="codeSalle" required>
                            <option value="">-- Sélectionner une salle --</option>
                            <c:forEach var="salle" items="${salles}">
                                <option value="${salle.codeSalle}">
                                    ${salle.codeSalle} - ${salle.designation}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="date">Date</label>
                        <input type="date" id="date" name="date" required>
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" onclick="fermerModal()">Annuler</button>
                    <button type="submit" class="btn btn-primary" id="btnSubmit">Enregistrer</button>
                </div>
            </form>
        </div>
    </div>

    <script src="https://unpkg.com/lucide@latest/dist/umd/lucide.js"></script>
    <script>
        const contextPath = "${pageContext.request.contextPath}";
        const apiUrl = contextPath + "/api/occuper";

        let modeEdition = false;
        let ancienCodeProf = null;
        let ancienCodeSalle = null;
        let ancienneDate = null;

        const modal = document.getElementById("modalOccupation");
        const modalTitle = document.getElementById("modalTitle");
        const form = document.getElementById("formOccupation");
        const formError = document.getElementById("formError");
        const selectCodeProf = document.getElementById("codeProf");
        const selectCodeSalle = document.getElementById("codeSalle");
        const inputDate = document.getElementById("date");
        const tableBody = document.getElementById("tableOccupations");

        // ===== Ouvrir modal en mode AJOUT =====
        function ouvrirModalAjout() {
            modeEdition = false;
            ancienCodeProf = null;
            ancienCodeSalle = null;
            ancienneDate = null;

            modalTitle.textContent = "Nouvelle occupation";
            form.reset();
            selectCodeProf.disabled = false;
            selectCodeSalle.disabled = false;

            masquerErreur();
            modal.classList.add("is-open");
        }

        // ===== Ouvrir modal en mode MODIFICATION =====
        function ouvrirModalModification(bouton) {
            modeEdition = true;

            ancienCodeProf = bouton.dataset.codeProf;
            ancienCodeSalle = bouton.dataset.codeSalle;
            ancienneDate = bouton.dataset.date;

            modalTitle.textContent = "Modifier l'occupation";

            selectCodeProf.value = ancienCodeProf;
            selectCodeSalle.value = ancienCodeSalle;
            inputDate.value = ancienneDate;

            // Le professeur et la salle font partie de la clé, on ne les change pas en édition
            selectCodeProf.disabled = true;
            selectCodeSalle.disabled = true;

            masquerErreur();
            modal.classList.add("is-open");
        }

        // ===== Fermer modal =====
        function fermerModal() {
            modal.classList.remove("is-open");
        }

        function afficherErreur(message) {
            formError.textContent = message;
            formError.classList.add("is-visible");
        }

        function masquerErreur() {
            formError.textContent = "";
            formError.classList.remove("is-visible");
        }

        // ===== Soumission du formulaire (Ajout ou Modification) =====
        form.addEventListener("submit", function (event) {
            event.preventDefault();

            const occupation = {
                codeProf: selectCodeProf.value,
                codeSalle: selectCodeSalle.value,
                date: inputDate.value
            };

            if (!occupation.codeProf || !occupation.codeSalle || !occupation.date) {
                afficherErreur("Veuillez remplir tous les champs obligatoires.");
                return;
            }

            if (modeEdition) {
                modifierOccupation(occupation);
            } else {
                ajouterOccupation(occupation);
            }
        });

        // ===== CREATE =====
        function ajouterOccupation(occupation) {
            fetch(apiUrl, {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify(occupation)
            })
                .then(function (response) {
                    if (!response.ok) {
                        throw new Error("Erreur lors de l'ajout de l'occupation.");
                    }
                    return response.json();
                })
                .then(function () {
                    fermerModal();
                    window.location.reload();
                })
                .catch(function (error) {
                    afficherErreur(error.message);
                });
        }

        // ===== UPDATE =====
        function modifierOccupation(occupation) {
            const url = apiUrl
                + "/" + encodeURIComponent(ancienCodeProf)
                + "/" + encodeURIComponent(ancienCodeSalle)
                + "/" + encodeURIComponent(ancienneDate);

            fetch(url, {
                method: "PUT",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify(occupation)
            })
                .then(function (response) {
                    if (!response.ok) {
                        throw new Error("Erreur lors de la modification de l'occupation.");
                    }
                    return response.json();
                })
                .then(function () {
                    fermerModal();
                    window.location.reload();
                })
                .catch(function (error) {
                    afficherErreur(error.message);
                });
        }

        // ===== DELETE =====
        function supprimerOccupation(codeProf, codeSalle, date) {
            const confirmation = confirm(
                "Voulez-vous vraiment supprimer cette occupation ("
                + codeProf + " / " + codeSalle + " / " + date + ") ?"
            );

            if (!confirmation) {
                return;
            }

            const url = apiUrl
                + "/" + encodeURIComponent(codeProf)
                + "/" + encodeURIComponent(codeSalle)
                + "/" + encodeURIComponent(date);

            fetch(url, {
                method: "DELETE"
            })
                .then(function (response) {
                    if (!response.ok) {
                        throw new Error("Erreur lors de la suppression de l'occupation.");
                    }

                    const selecteur =
                        'tr[data-code-prof="' + CSS.escape(codeProf) + '"]'
                        + '[data-code-salle="' + CSS.escape(codeSalle) + '"]'
                        + '[data-date="' + CSS.escape(date) + '"]';

                    const ligne = tableBody.querySelector(selecteur);
                    if (ligne) {
                        ligne.remove();
                    }

                    if (!tableBody.querySelector("tr:not(.empty-row)")) {
                        window.location.reload();
                    }
                })
                .catch(function (error) {
                    alert(error.message);
                });
        }

        document.getElementById("btnOpenCreate").addEventListener("click", ouvrirModalAjout);

        modal.addEventListener("click", function (event) {
            if (event.target === modal) {
                fermerModal();
            }
        });

        lucide.createIcons();
    </script>
</body>
</html>
