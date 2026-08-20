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
        href="${pageContext.request.contextPath}/css/salle.css">
    <title>Salle</title>

    
</head>
<body>
    <%@ include file="../layouts/sidebar.jsp" %>

    <main class="main-content">

        <div class="page-header">
            <div>
                <h1>Salles</h1>
                <p>Gestion des salles enregistrées</p>
            </div>

            <button type="button" class="btn btn-primary" id="btnOpenCreate">
                <i data-lucide="building-2"></i>
                Ajouter une salle
            </button>
        </div>

        <section class="panel">
            <div class="panel-header">
                <div>
                    <h2>Liste des salles</h2>
                    <div class="panel-subtitle">Toutes les salles enregistrées dans le système</div>
                </div>
                <i data-lucide="building-2" style="width:18px;height:18px;color:#9ca3af;"></i>
            </div>

            <div class="panel-body">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Code</th>
                            <th>Désignation</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody id="tableSalles">
                        <c:choose>
                            <c:when test="${empty salles}">
                                <tr class="empty-row">
                                    <td colspan="3">Aucune salle enregistrée.</td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="salle" items="${salles}">
                                    <tr data-code-salle="${salle.codeSalle}">
                                        <td class="cell-primary">${salle.codeSalle}</td>
                                        <td>${salle.designation}</td>
                                        <td>
                                            <div class="actions-cell">
                                                <button type="button"
                                                        class="btn-icon btn-edit"
                                                        title="Modifier"
                                                        data-code-salle="${salle.codeSalle}"
                                                        data-designation="${salle.designation}"
                                                        onclick="ouvrirModalModification(this)">
                                                    <i data-lucide="pencil"></i>
                                                </button>
                                                <button type="button"
                                                        class="btn-icon btn-delete"
                                                        title="Supprimer"
                                                        data-code-salle="${salle.codeSalle}"
                                                        onclick="supprimerSalle('${salle.codeSalle}')">
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
    <div class="modal-overlay" id="modalSalle">
        <div class="modal-box">
            <div class="modal-header">
                <h2 id="modalTitle">Ajouter une salle</h2>
                <button type="button" class="modal-close" onclick="fermerModal()">
                    <i data-lucide="x"></i>
                </button>
            </div>

            <form id="formSalle">
                <div class="modal-body">
                    <div class="form-error" id="formError"></div>

                    <div class="form-group">
                        <label for="codeSalle">Code salle</label>
                        <input type="text" id="codeSalle" name="codeSalle" required>
                    </div>

                    <div class="form-group">
                        <label for="designation">Désignation</label>
                        <input type="text" id="designation" name="designation" required>
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
        const apiUrl = contextPath + "/api/salles";

        let modeEdition = false;

        const modal = document.getElementById("modalSalle");
        const modalTitle = document.getElementById("modalTitle");
        const form = document.getElementById("formSalle");
        const formError = document.getElementById("formError");
        const inputCodeSalle = document.getElementById("codeSalle");
        const inputDesignation = document.getElementById("designation");
        const tableBody = document.getElementById("tableSalles");

        // ===== Ouvrir modal en mode AJOUT =====
        function ouvrirModalAjout() {
            modeEdition = false;
            modalTitle.textContent = "Ajouter une salle";
            form.reset();
            inputCodeSalle.disabled = false;
            masquerErreur();
            modal.classList.add("is-open");
        }

        // ===== Ouvrir modal en mode MODIFICATION =====
        function ouvrirModalModification(bouton) {
            modeEdition = true;
            modalTitle.textContent = "Modifier la salle";

            inputCodeSalle.value = bouton.dataset.codeSalle;
            inputDesignation.value = bouton.dataset.designation;

            // Le code salle est la clé, on ne le modifie pas en édition
            inputCodeSalle.disabled = true;

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

            const salle = {
                codeSalle: inputCodeSalle.value.trim(),
                designation: inputDesignation.value.trim()
            };

            if (!salle.codeSalle || !salle.designation) {
                afficherErreur("Veuillez remplir tous les champs obligatoires.");
                return;
            }

            if (modeEdition) {
                modifierSalle(salle);
            } else {
                ajouterSalle(salle);
            }
        });

        // ===== CREATE =====
        function ajouterSalle(salle) {
            fetch(apiUrl, {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify(salle)
            })
                .then(function (response) {
                    if (!response.ok) {
                        throw new Error("Erreur lors de l'ajout de la salle.");
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
        function modifierSalle(salle) {
            fetch(apiUrl + "/" + encodeURIComponent(salle.codeSalle), {
                method: "PUT",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify(salle)
            })
                .then(function (response) {
                    if (!response.ok) {
                        throw new Error("Erreur lors de la modification de la salle.");
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
        function supprimerSalle(codeSalle) {
            const confirmation = confirm(
                "Voulez-vous vraiment supprimer la salle " + codeSalle + " ?"
            );

            if (!confirmation) {
                return;
            }

            fetch(apiUrl + "/" + encodeURIComponent(codeSalle), {
                method: "DELETE"
            })
                .then(function (response) {
                    if (!response.ok) {
                        throw new Error("Erreur lors de la suppression de la salle.");
                    }

                    const ligne = tableBody.querySelector(
                        'tr[data-code-salle="' + CSS.escape(codeSalle) + '"]'
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
