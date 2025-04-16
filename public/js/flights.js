const cities = ["DEL", "JFK", "BOM", "CDG", "SYD", "CAI", "LAX", "FRA", "ROM", "MEL"];
const carriers = [
  { name: "Air India", logo: "/assests/airlinelogos/airindia.png", bookingLink: "https://www.airindia.com" },
  { name: "Qatar Airways", logo: "/assests/airlinelogos/qatar.png", bookingLink: "https://www.qatarairways.com" },
  { name: "Emirates", logo: "/assests/airlinelogos/emirates.png", bookingLink: "https://www.emirates.com" },
  { name: "Air France", logo: "/assests/airlinelogos/airfrance.png", bookingLink: "https://wwws.airfrance.us" },
  { name: "EgyptAir", logo: "/assests/airlinelogos/egyptair.png", bookingLink: "https://www.egyptair.com" },
  { name: "Qantas", logo: "/assests/airlinelogos/qantas.jpg", bookingLink: "https://www.qantas.com" },
  { name: "Lufthansa", logo: "/assests/airlinelogos/lufthansa.png", bookingLink: "https://www.lufthansa.com" },
  { name: "Delta Air Lines", logo: "/assests/airlinelogos/delta.png", bookingLink: "https://www.delta.com" },
  { name: "United Airlines", logo: "/assests/airlinelogos/united.svg", bookingLink: "https://www.united.com" },
  { name: "American Airlines", logo: "/assests/airlinelogos/american1.svg", bookingLink: "https://www.aa.com" }
];

const flights = [];

function getRandomItem(arr) {
  return arr[Math.floor(Math.random() * arr.length)];
}

function getRandomDuration() {
  return 60 + Math.floor(Math.random() * 240);
}

function formatDuration(minutes) {
  const hrs = Math.floor(minutes / 60);
  const mins = minutes % 60;
  return `${hrs}h ${mins}m`;
}

function getDateOffset(base, days) {
  const date = new Date(base);
  date.setDate(date.getDate() + days);
  return date.toISOString().split("T")[0];
}

function formatTime(hour, minute) {
  return `${hour.toString().padStart(2, '0')}:${minute.toString().padStart(2, '0')}`;
}

function addMinutes(hour, minute, duration) {
  const totalMinutes = hour * 60 + minute + duration;
  const arrivalHour = Math.floor(totalMinutes / 60) % 24;
  const arrivalMinute = totalMinutes % 60;
  return { hour: arrivalHour, minute: arrivalMinute };
}

function getRandomDepartureTime() {
  const hour = Math.floor(Math.random() * 14) + 6;
  const minute = Math.floor(Math.random() * 60);
  return { hour, minute };
}

function generateFlights(departureDate, arrivalDate) {
  const depDateObj = new Date(departureDate);
  flights.length = 0;

  cities.forEach((src) => {
    cities.forEach((dest) => {
      if (src !== dest) {
        for (let i = 0; i < 3; i++) {
          const carrierObj = getRandomItem(carriers);
          const flightDepartureDate = getDateOffset(depDateObj, i);
          const duration = getRandomDuration();
          const depTime = getRandomDepartureTime();
          const arrTime = addMinutes(depTime.hour, depTime.minute, duration);

          const returnDuration = getRandomDuration();
          const retDepTime = getRandomDepartureTime();
          const retArrTime = addMinutes(retDepTime.hour, retDepTime.minute, returnDuration);

          flights.push({
            carrier: carrierObj.name,
            logo: carrierObj.logo,
            currency: "₹",
            nodes: [src, dest],
            outbound: {
              departureDate: flightDepartureDate,
              arrivalDate: flightDepartureDate,
              departureTime: formatTime(depTime.hour, depTime.minute),
              arrivalTime: formatTime(arrTime.hour, arrTime.minute),
              time: duration,
              price: 9000 + Math.floor(Math.random() * 2000)
            },
            return: {
              departureDate: arrivalDate,
              arrivalDate: arrivalDate,
              departureTime: formatTime(retDepTime.hour, retDepTime.minute),
              arrivalTime: formatTime(retArrTime.hour, retArrTime.minute),
              time: returnDuration,
              price: 9000 + Math.floor(Math.random() * 2000)
            }
          });
        }
      }
    });
  });
}

function searchFlights(from, to) {
  if (!from || !to || from === to) return [];
  return flights.filter(f => f.nodes[0] === from && f.nodes[1] === to);
}

function populateDropdowns() {
  const dep = document.getElementById("departureCity");
  const arr = document.getElementById("arrivalCity");
  cities.forEach(city => {
    const opt1 = document.createElement("option");
    opt1.value = city;
    opt1.text = city;
    dep.appendChild(opt1);

    const opt2 = document.createElement("option");
    opt2.value = city;
    opt2.text = city;
    arr.appendChild(opt2);
  });
}

function updatePrices() {
  const selectedClass = document.getElementById("class").value;
  const passengerCount = parseInt(document.getElementById("passengers").value) || 1;
  const classMultipliers = {
    economy: 1,
    premium: 1.3,
    business: 1.8,
    first: 2.5
  };
  const multiplier = classMultipliers[selectedClass];

  document.querySelectorAll(".ticket-pair").forEach((ticket, index) => {
    const outboundPriceElem = ticket.querySelector(".flight-item:nth-child(1) .flight-price");
    const returnPriceElem = ticket.querySelector(".flight-item:nth-child(2) .flight-price");
    const totalPriceElem = ticket.querySelector(".total-price-inside #totalPrice");

    const flight = flights[index];
    if (flight) {
      const newOutbound = Math.round(flight.outbound.price * multiplier);
      const newReturn = Math.round(flight.return.price * multiplier);
      const newTotal = (newOutbound + newReturn) * passengerCount;

      outboundPriceElem.textContent = `₹ ${newOutbound.toLocaleString()}`;
      returnPriceElem.textContent = `₹ ${newReturn.toLocaleString()}`;
      totalPriceElem.textContent = `₹ ${newTotal.toLocaleString()}`;
    }
  });
}

function handleSearch() {
  const from = document.getElementById("departureCity").value;
  const to = document.getElementById("arrivalCity").value;
  const departureDate = document.getElementById("deptdate").value;
  const arrivalDate = document.getElementById("arrdate").value;
  const selectedClass = document.getElementById("class").value;
  const passengerCount = parseInt(document.getElementById("passengers").value) || 1;

  if (!from || !to || from === to || !departureDate || !arrivalDate) {
    alert("Please fill all fields correctly.");
    return;
  }

  let results = flights.filter(f =>
    f.nodes[0] === from &&
    f.nodes[1] === to &&
    f.outbound.departureDate === departureDate &&
    f.return.departureDate === arrivalDate
  );

  while (results.length < 5) {
    const randomFlight = flights[Math.floor(Math.random() * flights.length)];
    if (!results.includes(randomFlight)) {
      results.push(randomFlight);
    }
  }

  const classMultipliers = {
    economy: 1,
    premium: 1.3,
    business: 1.8,
    first: 2.5
  };
  const multiplier = classMultipliers[selectedClass];

  results.forEach(f => {
    const carrierObj = carriers.find(c => c.name === f.carrier);
    f.bookingLink = carrierObj ? carrierObj.bookingLink :
      "https://www.google.com/search?q=" + encodeURIComponent(f.carrier + " flight booking");
  });

  const resultContainer = document.getElementById("results");

  if (results.length === 0) {
    resultContainer.innerHTML = `<p>No flights found between ${from} and ${to} on ${departureDate}</p>`;
    return;
  }

  resultContainer.innerHTML = results.map(f =>
    `<div>
      <div class="ticket-pair">
        <div class="flight-item">
          <img src="${f.logo}" class="airline-logo" alt="${f.carrier} logo"><br>
          <strong>${f.carrier}</strong> |<br>
          ${f.nodes[0]} to ${f.nodes[1]}<br>
          <div class="flight-time">${formatDuration(f.outbound.time)}</div>
          <p>Departure Date: ${f.outbound.departureDate}</p>
          <p>Arrival Date: ${f.outbound.arrivalDate}</p>
          <span class="flight-price">₹ ${(f.outbound.price * multiplier).toLocaleString()}</span><br>
        </div>

        <div class="flight-item">
          <img src="${f.logo}" class="airline-logo" alt="${f.carrier} logo"><br>
          <strong>${f.carrier}</strong> |<br>
          ${f.nodes[1]} to ${f.nodes[0]}<br>
          <div class="flight-time">${formatDuration(f.return.time)}</div>
          <p>Departure Date: ${f.return.departureDate}</p>
          <p>Arrival Date: ${f.return.arrivalDate}</p>
          <span class="flight-price">₹ ${(f.return.price * multiplier).toLocaleString()}</span><br>
        </div>

        <div class="total-price-inside">
          Total Price:
          <p id='totalPrice'> ₹ ${((f.outbound.price + f.return.price) * multiplier * passengerCount).toLocaleString()}</p><br>
          <a href="${f.bookingLink}" target="_blank">
            <button id='bookNowBtn'>Book Now</button>
          </a>
        </div>
      </div>
    </div>`
  ).join('');

  document.getElementById("results-section").scrollIntoView({ behavior: "smooth" });
}

document.addEventListener("DOMContentLoaded", function () {
  populateDropdowns();

  const today = new Date().toISOString().split("T")[0];
  document.getElementById("deptdate").setAttribute("min", today);
  document.getElementById("arrdate").setAttribute("min", today);

  document.getElementById("search-btn").addEventListener("click", () => {
    const departureDate = document.getElementById("deptdate").value;
    const arrivalDate = document.getElementById("arrdate").value;

    if (!departureDate || !arrivalDate) {
      alert("Please select both departure and return dates.");
      return;
    }

    if (new Date(arrivalDate) <= new Date(departureDate)) {
      alert("Return date must be after departure date.");
      return;
    }

    generateFlights(departureDate, arrivalDate);
    handleSearch();
  });

  document.getElementById("passengers").addEventListener("input", updatePrices);
  document.getElementById("class").addEventListener("change", updatePrices);
});
