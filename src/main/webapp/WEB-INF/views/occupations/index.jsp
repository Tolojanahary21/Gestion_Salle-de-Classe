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

    <%-- ===== MODAL AJOUT ===== --%>
    <div class="modal-overlay" id="modalAjoutOccupation">
        <div class="modal-box">
            <div class="modal-header">
                <h2>Nouvelle occupation</h2>
                <button type="button" class="modal-close" onclick="fermerModalAjout()">
                    <i data-lucide="x"></i>
                </button>
            </div>

            <form id="formAjoutOccupation">
                <div class="modal-body">
                    <div class="form-error" id="formErrorAjout"></div>

                    <div class="form-group">
                        <label for="ajoutCodeProf">Professeur</label>
                        <select id="ajoutCodeProf" name="codeProf" required>
                            <option value="">-- Sélectionner un professeur --</option>
                            <c:forEach var="prof" items="${professeurs}">
                                <option value="${prof.codeProf}">
                                    ${prof.codeProf} - ${prof.nom} ${prof.prenom}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="ajoutCodeSalle">Salle</label>
                        <select id="ajoutCodeSalle" name="codeSalle" required>
                            <option value="">-- Sélectionner une salle --</option>
                            <c:forEach var="salle" items="${salles}">
                                <option value="${salle.codeSalle}">
                                    ${salle.codeSalle} - ${salle.designation}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="ajoutDate">Date</label>
                        <input type="date" id="ajoutDate" name="date" required>
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" onclick="fermerModalAjout()">Annuler</button>
                    <button type="submit" class="btn btn-primary" id="btnSubmitAjout">Enregistrer</button>
                </div>
            </form>
        </div>
    </div>

    <%-- ===== MODAL MODIFICATION ===== --%>
    <div class="modal-overlay" id="modalModificationOccupation">
        <div class="modal-box">
            <div class="modal-header">
                <h2>Modifier l'occupation</h2>
                <button type="button" class="modal-close" onclick="fermerModalModification()">
                    <i data-lucide="x"></i>
                </button>
            </div>

            <form id="formModificationOccupation">
                <div class="modal-body">
                    <div class="form-error" id="formErrorModification"></div>

                    <div class="form-group">
                        <label for="modifCodeProf">Professeur</label>
                        <select id="modifCodeProf" name="codeProf" disabled>
                            <option value="">-- Sélectionner un professeur --</option>
                            <c:forEach var="prof" items="${professeurs}">
                                <option value="${prof.codeProf}">
                                    ${prof.codeProf} - ${prof.nom} ${prof.prenom}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="modifCodeSalle">Salle</label>
                        <select id="modifCodeSalle" name="codeSalle" disabled>
                            <option value="">-- Sélectionner une salle --</option>
                            <c:forEach var="salle" items="${salles}">
                                <option value="${salle.codeSalle}">
                                    ${salle.codeSalle} - ${salle.designation}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="modifDate">Date</label>
                        <input type="date" id="modifDate" name="date" required>
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" onclick="fermerModalModification()">Annuler</button>
                    <button type="submit" class="btn btn-primary" id="btnSubmitModification">Enregistrer</button>
                </div>
            </form>
        </div>
    </div>

    <script src="https://unpkg.com/lucide@latest/dist/umd/lucide.js"></script>
    <script>
        const contextPath = "${pageContext.request.contextPath}";
        const apiUrl = contextPath + "/api/occuper";

        const tableBody = document.getElementById("tableOccupations");

        // ================================================================
        // ===== AJOUT =====
        // ================================================================

        const modalAjout = document.getElementById("modalAjoutOccupation");
        const formAjout = document.getElementById("formAjoutOccupation");
        const formErrorAjout = document.getElementById("formErrorAjout");
        const ajoutCodeProf = document.getElementById("ajoutCodeProf");
        const ajoutCodeSalle = document.getElementById("ajoutCodeSalle");
        const ajoutDate = document.getElementById("ajoutDate");
        const btnSubmitAjout = document.getElementById("btnSubmitAjout");

        function ouvrirModalAjout() {
            formAjout.reset();
            masquerErreurAjout();
            modalAjout.classList.add("is-open");
        }

        function fermerModalAjout() {
            modalAjout.classList.remove("is-open");
        }

        function afficherErreurAjout(message) {
            formErrorAjout.textContent = message;
            formErrorAjout.classList.add("is-visible");
        }

        function masquerErreurAjout() {
            formErrorAjout.textContent = "";
            formErrorAjout.classList.remove("is-visible");
        }

        formAjout.addEventListener("submit", function (event) {
            event.preventDefault();
            masquerErreurAjout();

            const occupation = {
                codeProf: ajoutCodeProf.value,
                codeSalle: ajoutCodeSalle.value,
                date: ajoutDate.value
            };

            if (!occupation.codeProf || !occupation.codeSalle || !occupation.date) {
                afficherErreurAjout("Veuillez remplir tous les champs obligatoires.");
                return;
            }

            ajouterOccupation(occupation);
        });

        function ajouterOccupation(occupation) {
            btnSubmitAjout.disabled = true;

            fetch(apiUrl, {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify(occupation)
            })
                .then(function (response) {
                    if (!response.ok) {
                        return extraireMessageErreur(
                            response,
                            "Erreur lors de l'ajout de l'occupation."
                        ).then(function (message) {
                            throw new Error(message);
                        });
                    }
                    return response.json();
                })
                .then(function () {
                    fermerModalAjout();
                    window.location.reload();
                })
                .catch(function (error) {
                    afficherErreurAjout(error.message);
                })
                .finally(function () {
                    btnSubmitAjout.disabled = false;
                });
        }

        // ================================================================
        // ===== MODIFICATION =====
        // ================================================================

        const modalModification = document.getElementById("modalModificationOccupation");
        const formModification = document.getElementById("formModificationOccupation");
        const formErrorModification = document.getElementById("formErrorModification");
        const modifCodeProf = document.getElementById("modifCodeProf");
        const modifCodeSalle = document.getElementById("modifCodeSalle");
        const modifDate = document.getElementById("modifDate");
        const btnSubmitModification = document.getElementById("btnSubmitModification");

        let ancienCodeProf = null;
        let ancienCodeSalle = null;
        let ancienneDate = null;

        function ouvrirModalModification(bouton) {
            ancienCodeProf = bouton.dataset.codeProf;
            ancienCodeSalle = bouton.dataset.codeSalle;
            ancienneDate = bouton.dataset.date;

            modifCodeProf.value = ancienCodeProf;
            modifCodeSalle.value = ancienCodeSalle;
            modifDate.value = ancienneDate;

            masquerErreurModification();
            modalModification.classList.add("is-open");
        }

        function fermerModalModification() {
            modalModification.classList.remove("is-open");
        }

        function afficherErreurModification(message) {
            formErrorModification.textContent = message;
            formErrorModification.classList.add("is-visible");
        }

        function masquerErreurModification() {
            formErrorModification.textContent = "";
            formErrorModification.classList.remove("is-visible");
        }

        formModification.addEventListener("submit", function (event) {
            event.preventDefault();
            masquerErreurModification();

            if (!modifDate.value) {
                afficherErreurModification("Veuillez indiquer une date.");
                return;
            }

            modifierOccupation({
                codeProf: ancienCodeProf,
                codeSalle: ancienCodeSalle,
                date: modifDate.value
            });
        });

        function modifierOccupation(occupation) {
            btnSubmitModification.disabled = true;

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
                        return extraireMessageErreur(
                            response,
                            "Erreur lors de la modification de l'occupation."
                        ).then(function (message) {
                            throw new Error(message);
                        });
                    }
                    return response.json();
                })
                .then(function () {
                    fermerModalModification();
                    window.location.reload();
                })
                .catch(function (error) {
                    afficherErreurModification(error.message);
                })
                .finally(function () {
                    btnSubmitModification.disabled = false;
                });
        }

        // ================================================================
        // ===== SUPPRESSION =====
        // ================================================================

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
                        return extraireMessageErreur(
                            response,
                            "Erreur lors de la suppression de l'occupation."
                        ).then(function (message) {
                            throw new Error(message);
                        });
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

        // ================================================================
        // ===== UTILITAIRE : extraction du message d'erreur du backend =====
        // ================================================================

        function extraireMessageErreur(response, messageParDefaut) {
            return response.text().then(function (texte) {
                if (!texte) {
                    return messageParDefaut;
                }
                try {
                    const donnees = JSON.parse(texte);
                    return donnees.message || donnees.error || messageParDefaut;
                } catch (e) {
                    return messageParDefaut;
                }
            }).catch(function () {
                return messageParDefaut;
            });
        }

        // ================================================================
        // ===== INITIALISATION =====
        // ================================================================

        document.getElementById("btnOpenCreate").addEventListener("click", ouvrirModalAjout);

        // Ouverture automatique depuis le dashboard (?action=ajouter)
        if (new URLSearchParams(window.location.search).get("action") === "ajouter") {
            ouvrirModalAjout();
        }

        // modalAjout.addEventListener("click", function (event) {
        //     if (event.target === modalAjout) {
        //         fermerModalAjout();
        //     }
        // });

        // modalModification.addEventListener("click", function (event) {
        //     if (event.target === modalModification) {
        //         fermerModalModification();
        //     }
        // });

        lucide.createIcons();
    </script>
</body>
</html>
