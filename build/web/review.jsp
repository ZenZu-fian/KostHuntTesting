<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.Map" %>
<!DOCTYPE html>
<html lang="id">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Berikan Rating Kamu - KostHunt</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
                background-color: #f8f9fa;
                min-height: 100vh;
            }

            .container {
                max-width: 650px;
                margin: 60px auto;
                padding: 0 20px;
            }

            .review-card {
                background: white;
                border-radius: 8px;
                padding: 50px 40px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.08);
            }

            .review-title {
                text-align: center;
                font-size: 24px;
                font-weight: 600;
                color: #1f2937;
                margin-bottom: 40px;
            }

            .star-rating {
                display: flex;
                justify-content: center;
                gap: 15px;
                margin-bottom: 40px;
            }

            .star-rating input[type="radio"] {
                display: none;
            }

            .star-rating label {
                font-size: 55px;
                cursor: pointer;
                transition: all 0.2s ease;
            }

            .star-rating label i {
                color: #d1d5db;
            }

            .star-rating label:hover i {
                color: #fbbf24;
            }

            .star-rating label.active i {
                color: #fbbf24;
            }

            .comment-section {
                margin-bottom: 30px;
            }

            .comment-textarea {
                width: 100%;
                min-height: 180px;
                padding: 20px;
                border: 2px solid #d1d5db;
                border-radius: 8px;
                font-size: 15px;
                font-family: inherit;
                resize: vertical;
                transition: all 0.3s;
            }

            .comment-textarea:focus {
                outline: none;
                border-color: #4A90E2;
            }

            .comment-textarea::placeholder {
                color: #9ca3af;
            }

            .btn-submit {
                width: 100%;
                padding: 15px;
                background: #4A90E2;
                color: white;
                border: none;
                border-radius: 8px;
                font-size: 16px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s;
            }

            .btn-submit:hover {
                background: #357ab7;
            }

            .btn-submit:disabled {
                background: #9ca3af;
                cursor: not-allowed;
            }

            .kost-info {
                background: #f3f4f6;
                padding: 20px;
                border-radius: 8px;
                margin-bottom: 30px;
                text-align: center;
            }

            .kost-name {
                font-weight: 600;
                color: #1f2937;
                font-size: 18px;
                margin-bottom: 8px;
            }

            .kost-detail {
                color: #6b7280;
                font-size: 14px;
            }

            .back-link {
                display: block;
                text-align: center;
                color: #6b7280;
                text-decoration: none;
                margin-top: 20px;
                font-size: 14px;
            }

            .back-link:hover {
                color: #4A90E2;
            }

            @media (max-width: 768px) {
                .container {
                    margin: 30px auto;
                    padding: 0 15px;
                }

                .review-card {
                    padding: 35px 25px;
                }

                .star-rating label {
                    font-size: 45px;
                }

                .star-rating {
                    gap: 10px;
                }
            }
        </style>
    </head>
    <body>
        <%
            Map<String, Object> reviewData = (Map<String, Object>) request.getAttribute("reviewData");
            if (reviewData == null) {
                response.sendRedirect("tenantDashboard");
                return;
            }

            String userName = (String) session.getAttribute("user");
            if (userName == null) {
                response.sendRedirect("login.jsp");
                return;
            }
        %>

        <!-- Include Header -->
        <jsp:include page="header.jsp" />

        <div class="container">
            <div class="review-card">
                <h1 class="review-title">Berikan Rating Kamu</h1>

                <div class="kost-info">
                    <div class="kost-name"><%= reviewData.get("kost_name")%></div>
                    <div class="kost-detail">
                        Kamar Nomor <%= reviewData.get("room_number")%> • <%= reviewData.get("location")%>
                    </div>
                </div>

                <form action="review" method="POST" id="reviewForm">
                    <input type="hidden" name="action" value="create">
                    <input type="hidden" name="roomId" value="<%= reviewData.get("room_id")%>">
                    <input type="hidden" name="kostId" value="<%= reviewData.get("kost_id")%>">

                    <div class="star-rating" id="starRating">
                        <label for="star1" data-rating="1"><i class="far fa-star"></i></label>
                        <input type="radio" name="rating" id="star1" value="1" required>

                        <label for="star2" data-rating="2"><i class="far fa-star"></i></label>
                        <input type="radio" name="rating" id="star2" value="2">

                        <label for="star3" data-rating="3"><i class="far fa-star"></i></label>
                        <input type="radio" name="rating" id="star3" value="3">

                        <label for="star4" data-rating="4"><i class="far fa-star"></i></label>
                        <input type="radio" name="rating" id="star4" value="4">

                        <label for="star5" data-rating="5"><i class="far fa-star"></i></label>
                        <input type="radio" name="rating" id="star5" value="5">
                    </div>

                    <div class="comment-section">
                        <textarea 
                            name="comment" 
                            class="comment-textarea" 
                            placeholder="bagikan pengalaman anda"
                            required
                            ></textarea>
                    </div>

                    <button type="submit" class="btn-submit" id="submitBtn" disabled>
                        Submit
                    </button>
                </form>

                <a href="tenantDashboard" class="back-link">
                    ← Kembali ke Dashboard
                </a>
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            const starRating = document.getElementById('starRating');
            const starLabels = starRating.querySelectorAll('label');
            const ratingInputs = document.querySelectorAll('input[name="rating"]');
            const commentTextarea = document.querySelector('textarea[name="comment"]');
            const submitBtn = document.getElementById('submitBtn');

            let selectedRating = null;

            // Handle star click
            starLabels.forEach(label => {
                label.addEventListener('click', function () {
                    const rating = this.getAttribute('data-rating');
                    selectedRating = rating;
                    updateStars(rating);
                    checkFormValid();
                });

                // Hover effect
                label.addEventListener('mouseenter', function () {
                    const rating = this.getAttribute('data-rating');
                    highlightStars(rating);
                });
            });

            // Reset stars on mouse leave
            starRating.addEventListener('mouseleave', function () {
                if (selectedRating) {
                    updateStars(selectedRating);
                } else {
                    resetStars();
                }
            });

            function highlightStars(rating) {
                starLabels.forEach(label => {
                    const labelRating = parseInt(label.getAttribute('data-rating'));
                    const icon = label.querySelector('i');

                    if (labelRating <= rating) {
                        label.classList.add('active');
                        icon.className = 'fas fa-star';
                    } else {
                        label.classList.remove('active');
                        icon.className = 'far fa-star';
                    }
                });
            }

            function updateStars(rating) {
                starLabels.forEach(label => {
                    const labelRating = parseInt(label.getAttribute('data-rating'));
                    const icon = label.querySelector('i');

                    if (labelRating <= rating) {
                        label.classList.add('active');
                        icon.className = 'fas fa-star';
                    } else {
                        label.classList.remove('active');
                        icon.className = 'far fa-star';
                    }
                });
            }

            function resetStars() {
                starLabels.forEach(label => {
                    label.classList.remove('active');
                    const icon = label.querySelector('i');
                    icon.className = 'far fa-star';
                });
            }

            // Check if form is valid
            commentTextarea.addEventListener('input', function () {
                checkFormValid();
            });

            function checkFormValid() {
                const commentValid = commentTextarea.value.trim().length >= 5;
                const ratingValid = selectedRating !== null;

                submitBtn.disabled = !(commentValid && ratingValid);
            }

            // Form submission validation
            document.getElementById('reviewForm').addEventListener('submit', function (e) {
                const comment = commentTextarea.value.trim();

                if (comment.length < 5) {
                    e.preventDefault();
                    alert('Komentar minimal 10 karakter!');
                    return;
                }

                if (!selectedRating) {
                    e.preventDefault();
                    alert('Silakan pilih rating terlebih dahulu!');
                    return;
                }

                if (!confirm('Kirim review ini?')) {
                    e.preventDefault();
                }
            });
        </script>
    </body>
</html>