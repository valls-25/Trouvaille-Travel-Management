document.addEventListener("DOMContentLoaded", function () {
  // Page Transition Setup
  const pageTransition = document.querySelector(".page-transition");
  const transitionContent = document.querySelector(".transition-content");
  const body = document.querySelector("body");

  // Check if we're arriving from another page with transition
  const isPageLoad = sessionStorage.getItem("pageIsLoading");
  if (isPageLoad === "true") {
    // IMPORTANT: Force the transition to be visible immediately when page loads
    document.body.classList.add("loading");
    pageTransition.style.transition = "none";
    pageTransition.style.transform = "translateY(0)";

    // Force browser to recognize the above style changes before animating
    requestAnimationFrame(() => {
      requestAnimationFrame(() => {
        // Restore the transition effect and animate upward
        pageTransition.style.transition =
          "transform 0.7s cubic-bezier(0.7, 0, 0.3, 1)";
        pageTransition.style.transform = "translateY(-100%)";
        sessionStorage.removeItem("pageIsLoading");

        // Remove loading class after transition completes
        setTimeout(() => {
          document.body.classList.remove("loading");
        }, 1200);
      });
    });
  }

  // Function to change background with smooth transition
  function changeBackground(imageUrl) {
    gsap.to(body, {
      backgroundImage: `url("${imageUrl}")`,
      backgroundSize: "cover",
      backgroundPosition: "center",
      duration: 0.5,
      ease: "power2.inOut",
    });

    const newBg = document.createElement("div");
    newBg.style.position = "fixed";
    newBg.style.top = "0";
    newBg.style.left = "0";
    newBg.style.width = "100%";
    newBg.style.height = "100%";
    newBg.style.backgroundImage = `url("${imageUrl}")`;
    newBg.style.backgroundSize = "cover";
    newBg.style.backgroundPosition = "center";
    newBg.style.zIndex = "-1";
    newBg.style.opacity = "0";
    newBg.style.transition = "opacity 0.3s ease-in-out";

    document.body.appendChild(newBg);

    // Fade in new background
    setTimeout(() => {
      newBg.style.opacity = "1";
    }, 10);

    // Remove old background after transition
    setTimeout(() => {
      const oldBg = document.querySelector(".bg-fade");
      if (oldBg) oldBg.remove();
      newBg.classList.add("bg-fade");
    }, 600);
  }

  // Initialize Swiper
  const swiper = new Swiper(".swiper-container", {
    slidesPerView: 3,
    spaceBetween: 20,
    centeredSlides: true,
    loop: true,
    slideToClickedSlide: false,
    initialSlide: 0,
    mousewheel: true,
    keyboard: {
      enabled: true,
    },
    on: {
      init: function () {
        // Set initial background on page load
        const activeSlide = this.slides[this.activeIndex];
        const activeImage = activeSlide.querySelector("img");
        if (activeImage) {
          changeBackground(activeImage.src);
        }
      },
      slideChangeTransitionEnd: function () {
        // Get the active slide's image source
        const activeSlide = this.slides[this.activeIndex];
        const activeImage = activeSlide.querySelector("img");
        if (activeImage) {
          changeBackground(activeImage.src);
        }
      },
    },
  });

  // Card Flipping Logic
  const cards = document.querySelectorAll(".card");
  let currentlyFlippedCard = null;

  cards.forEach((card) => {
    card.addEventListener("click", function (e) {
      e.stopPropagation(); // Prevent slide change when clicking card

      // If there's a currently flipped card and it's not this one, flip it back
      if (currentlyFlippedCard && currentlyFlippedCard !== this) {
        currentlyFlippedCard.classList.remove("flipped");
      }

      // Toggle the current card
      this.classList.toggle("flipped");

      // Update the currently flipped card
      if (this.classList.contains("flipped")) {
        currentlyFlippedCard = this;
      } else {
        currentlyFlippedCard = null;
      }
    });
  });

  // Function to handle page transitions
  function handlePageTransition(e) {
    e.preventDefault();
    const target = e.currentTarget.getAttribute("href");

    // If going back to the main page, set which country to highlight
    if (target.includes("index.html")) {
      // France is at index 1
      sessionStorage.setItem("lastActiveCountry", "1");
    }

    // Show transition overlay (slide down from top)
    pageTransition.style.transform = "translateY(0)";

    // Show transition content after a small delay
    setTimeout(() => {
      // No opacity change needed since content is empty
    }, 300);

    // Set flag for next page to continue the animation
    sessionStorage.setItem("pageIsLoading", "true");

    // Navigate to the new page after transition completes
    setTimeout(() => {
      window.location.href = target;
    }, 1300);
  }

  // Add click event listeners to all transition links
  document.querySelectorAll(".transition-link").forEach((link) => {
    link.addEventListener("click", handlePageTransition);
  });
});
