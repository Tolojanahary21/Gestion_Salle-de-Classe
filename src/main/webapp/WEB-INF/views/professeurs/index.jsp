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

    <div style="display:flex; align-items:center; gap:8px; padding:8px 12px; min-width:260px; border:1px solid #e5e7eb; border-radius:8px; background:#ffffff;">
        <i data-lucide="search" style="width:16px; height:16px; color:#9ca3af; flex-shrink:0;"></i>
        <input type="text"
               id="rechercheProfesseur"
               placeholder="Rechercher par code ou nom..."
               autocomplete="off"
               style="flex:1; border:none; outline:none; background:transparent; font-size:13.5px; font-family:inherit; color:#111827;">
    </div>
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
// ================================================================
// ===== RECHERCHE DYNAMIQUE (par code ou nom/prénom) =====
// ================================================================

                const inputRecherche = document.getElementById("rechercheProfesseur");
                const lignesProfesseurs = Array.from(
                    tableBody.querySelectorAll("tr[data-code-prof]")
                );

                function normaliser(texte) {
                    return (texte || "")
                        .toString()
                        .normalize("NFD")
                        .replace(/[\u0300-\u036f]/g, "") // retire les accents
                        .toLowerCase()
                        .trim();
                }

                function filtrerProfesseurs() {
                    const terme = normaliser(inputRecherche.value);
                    let resultatsVisibles = 0;

                    lignesProfesseurs.forEach(function (ligne) {
                        const code = normaliser(ligne.dataset.codeProf);
                        const nom = normaliser(ligne.children[1].textContent);
                        const prenom = normaliser(ligne.children[2].textContent);

                        const correspond =
                            !terme ||
                            code.includes(terme) ||
                            nom.includes(terme) ||
                            prenom.includes(terme);

                        ligne.style.display = correspond ? "" : "none";

                        if (correspond) {
                            resultatsVisibles++;
                        }
                    });

                    let ligneAucunResultat = tableBody.querySelector(".empty-row-recherche");

                    if (resultatsVisibles === 0 && lignesProfesseurs.length > 0) {
                        if (!ligneAucunResultat) {
                            ligneAucunResultat = document.createElement("tr");
                            ligneAucunResultat.className = "empty-row empty-row-recherche";

                            const cellule = document.createElement("td");
                            cellule.colSpan = 5;
                            cellule.style.textAlign = "center";
                            cellule.style.padding = "30px";
                            cellule.style.color = "#9ca3af";
                            cellule.textContent = "Aucun professeur ne correspond à la recherche.";

                            ligneAucunResultat.appendChild(cellule);
                            tableBody.appendChild(ligneAucunResultat);
                        }
                    } else if (ligneAucunResultat) {
                        ligneAucunResultat.remove();
                    }
                }

                if (inputRecherche) {
                    inputRecherche.addEventListener("input", filtrerProfesseurs);
                }
        // modal.addEventListener("click", function (event) {
        //     if (event.target === modal) {
        //         fermerModal();
        //     }
        // });

        lucide.createIcons();
    </script>
</body>
</html>
