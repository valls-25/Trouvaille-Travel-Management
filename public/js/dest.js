document.addEventListener("DOMContentLoaded", function () {
  // Page Transition Setup
  const pageTransition = document.querySelector(".page-transition");
  const transitionContent = document.querySelector(".transition-content");

  // Check if we're arriving from another page with transition
  const isPageLoad = sessionStorage.getItem("pageIsLoading");
  if (isPageLoad === "true") {
    // IMPORTANT: Force the transition to be visible immediately when page loads
    // This helps especially with Chrome which may clear styles during page transitions
    document.body.classList.add("loading");
    pageTransition.style.transition = "none";
    pageTransition.style.transform = "translateY(0)";

    // Force browser to recognize the above style changes before animating
    // Use requestAnimationFrame for better browser compatibility
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

  // Function to handle page transitions
  function handlePageTransition(e) {
    e.preventDefault();
    const target = e.currentTarget.getAttribute("href");

    // If navigating to a country page, remember which country we're coming from
    if (target.includes("country/")) {
      // Store the current country index in session storage
      const currentIndex = swiper.realIndex;
      sessionStorage.setItem("lastActiveCountry", currentIndex);
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

  // Add click event listeners to all transition links (including any that might be added later)
  document.addEventListener("click", function (e) {
    if (
      e.target.classList.contains("transition-link") ||
      (e.target.parentElement &&
        e.target.parentElement.classList.contains("transition-link"))
    ) {
      const link = e.target.classList.contains("transition-link")
        ? e.target
        : e.target.parentElement;
      if (link.getAttribute("href")) {
        handlePageTransition.call(link, e);
      }
    }
  });

  const swiperWrapper = document.querySelector(".swiper-wrapper");
  const body = document.querySelector("body");
  const header = document.querySelector("header");
  // Sample Data (replace with your actual image URLs and descriptions)
  const cardData = [
    {
      image: "/assests/images/India/card.jpg",
      title: "India",
      description: "EXPLORE NOW",
      backgroundImage: "/assests/images/India/background.jpg",
    },
    {
      image: "/assests/images/France/card.jpg",
      title: "France",
      description: "EXPLORE NOW",
      backgroundImage: "/assests/images/France/background.jpg",
    },
    {
      image: "/assests/images/Egypt/card.jpg",
      title: "Egypt",
      description: "EXPLORE NOW",
      backgroundImage: "/assests/images/Egypt/background.jpg",
    },
    {
      image: "/assests/images/Australia/card.jpg",
      title: "Australia",
      description: "EXPLORE NOW",
      backgroundImage: "/assests/images/Australia/background.jpg",
    },
    {
      image: "/assests/images/USA/card.jpg",
      title: "USA",
      description: "EXPLORE NOW",
      backgroundImage: "/assests/images/USA/background.jpg",
    },
    {
      image: "/assests/images/Italy/card.jpg",
      title: "Italy",
      description: "EXPLORE NOW",
      backgroundImage: "/assests/images/Italy/background.jpg",
    },
  ];
  let swiper;

  // Function to update header content, making it clickable with transition
  function updateHeaderContent(index) {
    const title = cardData[index].title;

    // Change all descriptions to "EXPLORE NOW"
    const description = "EXPLORE NOW";

    // Clear header content
    header.querySelector("h1").innerHTML = "";
    header.querySelector("h1").textContent = title;

    // Create a clickable link for the description with transition effect
    const link = document.createElement("a");
    link.textContent = description;

    // Ensure the path is correctly formatted for all browsers
    link.href = `country/${title}/${title.toLowerCase()}.html`;

    link.classList.add("transition-link");
    link.style.color = "white";
    link.style.textDecoration = "none";

    // Add direct click event listener for the transition
    link.addEventListener("click", handlePageTransition);

    // Clear description content and append link
    header.querySelector("p").innerHTML = "";
    header.querySelector("p").appendChild(link);
  }

  // Function to create a card (Swiper Slide)
  function createCard(data) {
    const slide = document.createElement("div");
    slide.classList.add("swiper-slide");
    slide.style.backgroundImage = `url("${data.image}")`;
    slide.dataset.backgroundImage = data.backgroundImage;
    slide.dataset.title = data.title;
    slide.dataset.description = data.description;

    // Add click listener to change background
    slide.addEventListener("click", function () {
      const clickedIndex = cardData.findIndex(
        (card) => card.title === this.dataset.title
      );

      if (clickedIndex !== -1) {
        swiper.slideToLoop(clickedIndex, 300);
        // Update the background color and header text immediately upon click
        changeBackground(cardData[clickedIndex].backgroundImage);
        updateHeaderContent(clickedIndex);
      }
    });
    return slide;
  }

  // Function to change the background color
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

  // Populate Swiper with cards
  cardData.forEach((data) => {
    const slide = createCard(data);
    swiperWrapper.appendChild(slide);
  });

  // Get the last active country index from session storage (if any)
  const lastActiveCountry = sessionStorage.getItem("lastActiveCountry");
  const initialSlideIndex =
    lastActiveCountry !== null ? parseInt(lastActiveCountry) : 0;

  // Initialize Swiper
  swiper = new Swiper(".swiper-container", {
    slidesPerView: 3,
    spaceBetween: 20,
    centeredSlides: true,
    loop: true,
    initialSlide: initialSlideIndex,
    slideToClickedSlide: false,
    // Navigation arrows (optional)
    navigation: {
      nextEl: ".swiper-button-next",
      prevEl: ".swiper-button-prev",
    },
    // Enable mousewheel control (optional)
    mousewheel: true,
    keyboard: {
      enabled: true,
    },
    on: {
      slideChangeTransitionEnd: function () {
        // Update the background color to the active slide's color
        let realIndex = this.realIndex;
        changeBackground(cardData[realIndex].backgroundImage);
        updateHeaderContent(realIndex);
      },
    },
  });

  // Set initial background color and header text based on remembered country
  changeBackground(cardData[initialSlideIndex].backgroundImage);
  updateHeaderContent(initialSlideIndex);
});
