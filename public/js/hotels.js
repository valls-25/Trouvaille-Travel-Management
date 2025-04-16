angular.module('myComments', []).controller('commentsController', function ($scope) {
  // Default profile image path
  const defaultProfileImage = 'profile1.jpg';

  // Sample comments data
  $scope.dynamicComments = [
    {
      text: " The service was exceptional and the hotel exceeded my expectations.",
      userName: "Viozh Robert",
      location: "Paris",
      profileImage: "/assests/comments/profilepic1.jpg",
      rating: "4.5"
    },
    {
      text: "Amazing hotels! I'll definitely book through Trouvaille again.",
      userName: "Rachel Green",
      location: "New York",
      profileImage: "/assests/comments/profilepic2.jpg",
      rating: "4.5"
    },

    {
      text: " I never knew planning a trip could be this effortless.",
      userName: "Voilet Sorrengail",
      location: "Sydney",
      profileImage: "/assests/comments/profilepic3.jpg",
      rating: "4.5"
    }
  ];

  $scope.commentChunks = [];
  $scope.commentText = '';
  $scope.commentRating = 4.5; // Default rating
  $scope.isEditing = false;
  $scope.editIndex = -1;
  $scope.swiper = null;
  $scope.currentSlideIndex = 0;

  // Add a new comment
  $scope.addComment = function () {
    if ($scope.commentText) {
      let newComment = {
        text: $scope.commentText,
        userName: "Ashmi Vora",
        location: "Mumbai",
        profileImage: "/assests/comments/profilepic4.svg",
        rating: $scope.commentRating

      };

      $scope.dynamicComments.push(newComment);
      $scope.updateCommentChunks();
      $scope.commentText = '';
      $scope.commentRating = 4.5;
    }
  };

  $scope.updateCommentChunks = function () {
    $scope.commentChunks = [];
    for (let i = 0; i < $scope.dynamicComments.length; i += 3) {
      $scope.commentChunks.push($scope.dynamicComments.slice(i, i + 3));
    }
    if ($scope.swiper) {
      $scope.swiper.update();
    } else {
      $scope.initializeSwiper();
    }
  };

  $scope.initializeSwiper = function () {
    try {
      $scope.swiper = new Swiper('.swiper', {
        slidesPerView: 1,
        spaceBetween: 30,
        pagination: {
          el: '.swiper-pagination',
          clickable: true,
        },
        navigation: {
          nextEl: '.swiper-button-next',
          prevEl: '.swiper-button-prev',
        },
      });
    } catch (error) {
      console.error("Swiper initialization failed:", error);
    }
  };

  $scope.deleteComment = function (index) {
    $scope.dynamicComments.splice(index, 1);
    $scope.updateCommentChunks();
  };

  $scope.editComment = function (comment, index) {
    $scope.commentText = comment.text;
    $scope.commentRating = comment.rating;
    $scope.isEditing = true;
    $scope.editIndex = index;
  };

  $scope.updateComment = function () {
    if ($scope.editIndex !== -1) {
      $scope.dynamicComments[$scope.editIndex].text = $scope.commentText;
      $scope.dynamicComments[$scope.editIndex].rating = $scope.commentRating;
      $scope.commentText = '';
      $scope.commentRating = 4.5;
      $scope.isEditing = false;
      $scope.editIndex = -1;
      $scope.updateCommentChunks();
    }
  };

  $scope.cancelEdit = function () {
    $scope.commentText = '';
    $scope.commentRating = 4;
    $scope.commentRating = 4.5;
    $scope.isEditing = false;
    $scope.editIndex = -1;
  };

  $scope.$watch('commentChunks', function (newValue) {
    if (newValue && newValue.length > 0) {
      $scope.initializeSwiper();
    }
  }, true);
  $scope.updateCommentChunks();
});