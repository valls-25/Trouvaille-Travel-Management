const hotels=[ {
  name: "Trident Udaipur",
    location: "Udaipur, India",
    price: "$140/night",
    image: "/hotel/trident.jpg",
    website: "https://www.tridenthotels.com/hotels-in-udaipur"
}

,
{
name: "Sahara Star",
  location: "Mumbai, India",
  price: "$120/night",
  image: "/hotel/sahara.webp",
  website: "https://www.saharastar.com/"
}

,

{
name: "Hilton Hyde Park",
  location: "London, UK",
  price: "$160/night",
  image: "hotel/hilton.jpg",
  website: "https://www.hilton.com/en/hotels/lonhphn-hilton-london-hyde-park/?WT.mc_id=zINDA0EMEA1MB2PSH3Paid_ggl4ACBI_Brand_Destination5dkt6MULTIBR7EN8i81487387_121127567_71700000119552476&&&&&gad_source=1&gclid=CjwKCAjwzMi_BhACEiwAX4YZUMSj1Z0CuE4O_H-2PjRD99w2it6nIq7B63EkMGAJCI1yUvDYEaRA9hoClpgQAvD_BwE&gclsrc=aw.ds"
}

,
{
name: "Sax Paris",
  location: "Paris, France",
  price: "$190/night",
  image: "hotel/sax.jpg",
  website: "https://www.hilton.com/en/hotels/paretol-sax-paris/"
}

,
{
name: "Hotel Berchielli",
  location: "Florence, Italy",
  price: "$170/night",
  image: "hotel/berchielli.jpg",
  website: "https://www.berchielli.it/en/index"
}

,
{
name: "W",
  location: "Sydney, Australia",
  price: "$200/night",
  image: "hotel/w.jpg",
  website: "https://www.marriott.com/search/findHotels.mi?searchType=InCity&destinationAddress.city=&destinationAddress.stateProvince=&destinationAddress.country=AU&marriottBrands=WH&showMore=true&nst=paid&cid=PAI_GLB00050CK_GLE000BLSW_GLF000ONTQ&ppc=ppc&pId=intbppc&gad_source=1&gclid=CjwKCAjwzMi_BhACEiwAX4YZUMkTTD77BuXhZutuFHlIufkI4dTUHTWG_CtVJtX5hjCKdAtQbd6fWBoCP8oQAvD_BwE&gclsrc=aw.ds&deviceType=desktop-web&view=list#/0/"
}

,
{
name: "NH Collection Palazzo Cinquecento",
  location: "Cairo, Egypt",
  price: "$130/night",
  image: "hotel/nh.jpg",
  website: "https://www.nh-collection.com/en"
}

,
{
name: "InterContinental New York Barclay Hotel by IHG",
  location: "New York, USA",
  price: "$210/night",
  image: "hotel/intercontenental.jpg",
  website: "https://www.ihg.com/intercontinental/hotels/us/en/new-york/nycha/hoteldetail?Cm_mmc=FM-_-PS-_-B-_-Geo&dp=true&gad_source=1&gclid=CjwKCAjwzMi_BhACEiwAX4YZUI0BVWaWyoCX8wNUnfv-w6jLlc5_iuR69TvvfAbO638A45KXhAdTORoCik0QAvD_BwE"
}

,
{
name: "The Taj Mahal Palace",
  location: "Mumbai, India",
  price: "$125/night",
  image: "hotel/tajmumbai.jpg",
  website: "https://www.tajhotels.com/en-in/hotels/taj-mahal-palace-mumbai"
}

,
{
name: "TNH Collection Roma Fori Imperiali",
  location: "Rome, Italy",
  price: "$180/night",
  image: "hotel/nhrome.jpg",
  website: "https://www.nh-hotels.com/en/hotel/nh-collection-roma-fori-imperiali?campid=8435708&utm_campaign=nh_hotel&utm_source=google&utm_medium=cpc&utm_id=16575947994&utm_source_platform=sa360&gad_source=1&gclid=CjwKCAjwzMi_BhACEiwAX4YZUMg-uutqK_5EW11lBJFSEzSfUntU7GbEqBs1c9zSmiqLq_VZmqhgcBoCUDUQAvD_BwE&gclsrc=aw.ds",
}

,
{
name: "InterContinental Paris Le Grand by IHG",
  location: "Paris, France",
  price: "$220/night",
  image: "hotel/inetrparis.jpg",
  website: "https://www.online-reservations.com/?hotelid=42205&gacc=gmcc&gad_source=1&gclid=CjwKCAjwzMi_BhACEiwAX4YZUP8u-t6s2v2OQxPPjQaK5D8exUE09JTyM_3lvxCyaPtuIVotly2gGhoCc-UQAvD_BwE"
}

,
{
name: "Taj Palace",
  location: "Delhi, India",
  price: "$110/night",
  image: "hotel/tajpalace.jpeg",
  website: "https://www.tajhotels.com/en-in"
}

,
{
name: "PARKROYAL Langkawi Resort",
  location: "Los Angeles, USA",
  price: "$195/night",
  image: "hotel/parkroyal.jpg",
  website: "https://www.panpacific.com/en/hotels-and-resorts/pr-langkawi/offers.html?gad_source=1&gclid=CjwKCAjwzMi_BhACEiwAX4YZUJ2-cLYLCiB4xD7bN1Dm7N_pnCmp2sGb2q0mdlNn1i1WcA9zp7itJRoCO1QQAvD_BwE&gclsrc=aw.ds"
}

,
{
name: "Hilton Melbourne ",
  location: "Melbourne, Australia",
  price: "$185/night",
  image: "hotel/hilttonm.jpg",
  website: "https://www.hilton.com/en/hotels/melamhi-hilton-melbourne-little-queen-street/?WT.mc_id=zLADA0AU1HI2PSH3GGL4INTBPP5dkt6MELAMHI7en_&epid!_&ebuy!&&&&&gad_source=1&gclid=CjwKCAjwzMi_BhACEiwAX4YZUOgOC-4oT1hm6EYRkwj_XZg5u5dtJ5U5LNZh5wvwuhEEjHa2H69pZxoCaZEQAvD_BwE&gclsrc=aw.ds"
}

,
{
name: "Steigenberger Resort Achti",
  location: "Luxor, Egypt",
  price: "$115/night",
  image: "hotel/st.jpg",
  website: "https://hrewards.com/en/steigenberger-resort-achti-luxor"
}

,

{
name: "Fairmont San Francisco",
  location: "San Francisco, USA",
  price: "$205/night",
  image: "hotel/fairmont.jpg",
  website: "https://all.accor.com/booking/en/accor/hotels/san-francisco-ca-usa?compositions=1&stayplus=false&order_hotels_by=RECOMMENDATION&snu=false&hideWDR=false&productCode=null&accessibleRooms=false&hideHotelDetails=false&filters=eyJicmFuZHMiOlsiRkFJIl19&utm_term=mafm&gclid=CjwKCAjwzMi_BhACEiwAX4YZUC7mbmIaV_-wVvrAuktN4hHECItcBeocPi1BvgdDmWSgTuFyfrp3zhoCQ0AQAvD_BwE&utm_campaign=ppc-ach-mafm-goo-ncac-en-us-mix-sear&utm_medium=cpc&utm_source=google&utm_content=ncac-en-US-V7028"
}

,
{
name: "Grand Hotel Parker's",
  location: "Naples, Italy",
  price: "$165/night",
  image: "hotel/parker.jpg",
  website: "https://www.guestreservations.com/grand-hotel-parkers-naples/booking?utm_source=google&utm_medium=cpc&utm_campaign=991005079&gad_source=1&gclid=CjwKCAjwzMi_BhACEiwAX4YZUIMxHM-AHKNnoRVeHaJMYzr06XXYvh7MmZPT5RhpERQzmn_fQpxhLxoCfNIQAvD_BwE"
}

,

{
name: "Radisson Blu Hotel ",
  location: "Alexandria, Egypt",
  price: "$135/night",
  image: "hotel/radisson.jpg",
  website: "https://www.radissonhotels.com/en-us/hotels/radisson-blu-hotel-convention-center-alexandria"
}

];

const hotelCardContainer=document.getElementById('hotelCardContainer');
const locationInput=document.getElementById('locationInput');

function renderHotels(filteredHotels) {
  hotelCardContainer.innerHTML=''; // Clear previous results

  if (filteredHotels.length===0) {
    hotelCardContainer.innerHTML=`<p class="text-gray-600 text-center col-span-1 sm:col-span-2 md:col-span-3 lg:col-span-4">No hotels found for this location.</p>`;
    return;
  }

  filteredHotels.forEach(hotel=> {
      const card=document.createElement('div');
      card.className="bg-white rounded-lg shadow-lg overflow-hidden transform transition-transform hover:scale-105";

      card.innerHTML=` <img src="${hotel.image}" alt="${hotel.name}" class="w-full h-48 object-cover" > <div class="p-4" > <h3 class="text-lg font-bold" >$ {
        hotel.name
      }

      </h3> <p class="text-gray-600" >$ {
        hotel.location
      }

      </p> <div class="flex justify-between items-center mt-2" > <p class="text-gray-800 font-bold" >$ {
        hotel.price
      }

      </p> <a href="${hotel.website}" target="_blank" class="bg-gray-200 hover:bg-gray-300 text-gray-800 px-4 py-2 rounded-full text-sm transition-colors" >View Details</a> </div> </div> `;

      hotelCardContainer.appendChild(card);
    });
}

// Initial render
renderHotels(hotels);

// Filter as user types
locationInput.addEventListener('input', ()=> {
    const query=locationInput.value.trim().toLowerCase();
    const filtered=hotels.filter(hotel=> hotel.location.toLowerCase().includes(query));
    renderHotels(filtered);
  });