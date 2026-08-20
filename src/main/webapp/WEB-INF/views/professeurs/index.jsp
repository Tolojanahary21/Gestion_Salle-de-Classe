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
        href="${pageContext.request.contextPath}/css/professeur.css">
        <link rel="stylesheet"
        href="${pageContext.request.contextPath}/css/dashboard.css">
    <title>Professeur</title>

    
</head>
<body>
    <%@ include file="../layouts/sidebar.jsp" %>

    <main class="main-content">

        <div class="page-header">
            <div>
                <h1>Professeurs</h1>
                <p>Gestion des professeurs enregistrés</p>
            </div>

            <button type="button" class="btn btn-primary" id="btnOpenCreate">
                <i data-lucide="user-plus"></i>
                Ajouter un professeur
            </button>
        </div>

        <section class="panel">
            <div class="panel-header">
                <div>
                    <h2>Liste des professeurs</h2>
                    <div class="panel-subtitle">Tous les professeurs enregistrés dans le système</div>
                </div>
                <i data-lucide="graduation-cap" style="width:18px;height:18px;color:#9ca3af;"></i>
            </div>

            <div class="panel-body">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Code</th>
                            <th>Nom</th>
                            <th>Prénom</th>
                            <th>Grade</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody id="tableProfesseurs">
                        <c:choose>
                            <c:when test="${empty professeurs}">
                                <tr class="empty-row">
                                    <td colspan="5">Aucun professeur enregistré.</td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="prof" items="${professeurs}">
                                    <tr data-code-prof="${prof.codeProf}">
                                        <td class="cell-primary">${prof.codeProf}</td>
                                        <td>${prof.nom}</td>
                                        <td>${prof.prenom}</td>
                                        <td>${prof.grade}</td>
                                        <td>
                                            <div class="actions-cell">
                                                <button type="button"
                                                        class="btn-icon btn-edit"
                                                        title="Modifier"
                                                        data-code-prof="${prof.codeProf}"
                                                        data-nom="${prof.nom}"
                                                        data-prenom="${prof.prenom}"
                                                        data-grade="${prof.grade}"
                                                        onclick="ouvrirModalModification(this)">
                                                    <i data-lucide="pencil"></i>
                                                </button>
                                                <button type="button"
                                                        class="btn-icon btn-delete"
                                                        title="Supprimer"
                                                        data-code-prof="${prof.codeProf}"
                                                        onclick="supprimerProfesseur('${prof.codeProf}')">
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
    <div class="modal-overlay" id="modalProfesseur">
        <div class="modal-box">
            <div class="modal-header">
                <h2 id="modalTitle">Ajouter un professeur</h2>
                <button type="button" class="modal-close" onclick="fermerModal()">
                    <i data-lucide="x"></i>
                </button>
            </div>

            <form id="formProfesseur">
                <div class="modal-body">
                    <div class="form-error" id="formError"></div>

                    <div class="form-group">
                        <label for="codeProf">Code professeur</label>
                        <input type="text" id="codeProf" name="codeProf" required>
                    </div>

                    <div class="form-group">
                        <label for="nom">Nom</label>
                        <input type="text" id="nom" name="nom" required>
                    </div>

                    <div class="form-group">
                        <label for="prenom">Prénom</label>
                        <input type="text" id="prenom" name="prenom">
                    </div>

                    <div class="form-group">
                        <label for="grade">Grade</label>
                        <input type="text" id="grade" name="grade" required>
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
        const apiUrl = contextPath + "/api/profs";

        let modeEdition = false;

        const modal = document.getElementById("modalProfesseur");
        const modalTitle = document.getElementById("modalTitle");
        const form = document.getElementById("formProfesseur");
        const formError = document.getElementById("formError");
        const inputCodeProf = document.getElementById("codeProf");
        const inputNom = document.getElementById("nom");
        const inputPrenom = document.getElementById("prenom");
        const inputGrade = document.getElementById("grade");
        const tableBody = document.getElementById("tableProfesseurs");

        // ===== Ouvrir modal en mode AJOUT =====
        function ouvrirModalAjout() {
            modeEdition = false;
            modalTitle.textContent = "Ajouter un professeur";
            form.reset();
            inputCodeProf.disabled = false;
            masquerErreur();
            modal.classList.add("is-open");
        }

        // ===== Ouvrir modal en mode MODIFICATION =====
        function ouvrirModalModification(bouton) {
            modeEdition = true;
            modalTitle.textContent = "Modifier le professeur";

            inputCodeProf.value = bouton.dataset.codeProf;
            inputNom.value = bouton.dataset.nom;
            inputPrenom.value = bouton.dataset.prenom;
            inputGrade.value = bouton.dataset.grade;

            // Le code professeur est la clé, on ne le modifie pas en édition
            inputCodeProf.disabled = true;

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

            const professeur = {
                codeProf: inputCodeProf.value.trim(),
                nom: inputNom.value.trim(),
                prenom: inputPrenom.value.trim(),
                grade: inputGrade.value.trim()
            };

            if (!professeur.codeProf || !professeur.nom || !professeur.grade) {
                afficherErreur("Veuillez remplir tous les champs obligatoires.");
                return;
            }

            if (modeEdition) {
                modifierProfesseur(professeur);
            } else {
                ajouterProfesseur(professeur);
            }
        });

        // ===== CREATE =====
        function ajouterProfesseur(professeur) {
            fetch(apiUrl, {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify(professeur)
            })
                .then(function (response) {
                    if (!response.ok) {
                        throw new Error("Erreur lors de l'ajout du professeur.");
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
        function modifierProfesseur(professeur) {
            fetch(apiUrl + "/" + encodeURIComponent(professeur.codeProf), {
                method: "PUT",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify(professeur)
            })
                .then(function (response) {
                    if (!response.ok) {
                        throw new Error("Erreur lors de la modification du professeur.");
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
        function supprimerProfesseur(codeProf) {
            const confirmation = confirm(
                "Voulez-vous vraiment supprimer le professeur " + codeProf + " ?"
            );

            if (!confirmation) {
                return;
            }

            fetch(apiUrl + "/" + encodeURIComponent(codeProf), {
                method: "DELETE"
            })
                .then(function (response) {
                    if (!response.ok) {
                        throw new Error("Erreur lors de la suppression du professeur.");
                    }

                    const ligne = tableBody.querySelector(
                        'tr[data-code-prof="' + CSS.escape(codeProf) + '"]'
                    );
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

        // modal.addEventListener("click", function (event) {
        //     if (event.target === modal) {
        //         fermerModal();
        //     }
        // });

        lucide.createIcons();
    </script>
</body>
</html>
