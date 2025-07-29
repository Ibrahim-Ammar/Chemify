<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Chemistry Explorer</title>
  <style>
    body { 
      background: linear-gradient(135deg, #2c1157 0%, #4c1d95 50%, #2c1157 100%);
      color: white; 
      font-family: 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Open Sans', sans-serif;
      margin: 0; 
      padding: 0; 
      min-height: 100vh;
    }

    body::before {
      content: "";
      position: fixed;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background-image: 
        radial-gradient(circle at 20% 30%, rgba(255,255,255,0.1) 1px, transparent 1px),
        radial-gradient(circle at 80% 70%, rgba(255,255,255,0.1) 1px, transparent 1px);
      background-size: 50px 50px;
      z-index: -1;
      animation: float 20s linear infinite;
    }

    @keyframes float {
      0% { background-position: 0 0, 0 0; }
      100% { background-position: 100px 100px, -100px -100px; }
    }

    .science-header {
      text-align: center;
      padding: 20px 0;
      position: relative;
    }

    .molecule-animation {
      width: 60px;
      height: 120px;
      margin: 0 auto 20px;
      position: relative;
    }

    .atom {
      position: relative;
      width: 100%;
      height: 100%;
    }

    .nucleus {
      position: absolute;
      top: 50%;
      left: 50%;
      width: 20px;
      height: 20px;
      margin: -10px 0 0 -10px;
      background: #6d28d9;
      border-radius: 50%;
      box-shadow: 0 0 15px #6d28d9;
    }

    .orbit {
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      border: 2px solid rgba(255,255,255,0.2);
      border-radius: 50%;
    }

    .electron {
      position: absolute;
      top: 0;
      left: 50%;
      width: 8px;
      height: 8px;
      margin-left: -4px;
      margin-top: 55px;
      background: #a78bfa;
      border-radius: 50%;
      box-shadow: 0 0 10px #a78bfa;
      animation: electron-orbit 4s linear infinite;
    }

    .orbit:nth-child(2) {
      transform: rotate(60deg);
    }

    .orbit:nth-child(4) {
      transform: rotate(120deg);
    }

    .electron:nth-child(3) {
      animation-delay: -1.33s;
    }

    .electron:nth-child(5) {
      animation-delay: -2.66s;
    }

    @keyframes electron-orbit {
      0% { transform: rotate(0deg) translateX(60px) rotate(0deg); }
      100% { transform: rotate(360deg) translateX(60px) rotate(-360deg); }
    }

    h1 {
      font-size: 2.5rem;
      margin: 0;
      background: linear-gradient(90deg, #a78bfa, #6d28d9);
      -webkit-background-clip: text;
      background-clip: text;
      color: transparent;
      text-shadow: 0 2px 10px rgba(167, 139, 250, 0.3);
    }

    .container { 
      text-align: center; 
      padding: 40px; 
      background: rgba(91, 33, 182, 0.2);
      backdrop-filter: blur(10px);
      border-radius: 20px;
      box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
      max-width: 800px;
      margin: 40px auto;
      border: 1px solid rgba(255, 255, 255, 0.1);
    }

    img.robot { 
      width: 180px; 
      margin-bottom: 20px;
      filter: drop-shadow(0 0 15px rgba(110, 231, 183, 0.5));
      transition: transform 0.5s ease;
    }

    img.robot:hover {
      transform: rotate(10deg) scale(1.1);
    }

    button { 
      background: linear-gradient(135deg, #6b21a8 0%, #4f46e5 100%);
      color: white; 
      padding: 15px 30px; 
      margin: 10px; 
      border: none; 
      border-radius: 30px; 
      font-size: 18px; 
      cursor: pointer; 
      transition: all 0.3s ease;
      box-shadow: 0 4px 15px rgba(107, 33, 168, 0.4);
      position: relative;
      overflow: hidden;
    }

    button:hover {
      transform: translateY(-3px);
      box-shadow: 0 6px 20px rgba(107, 33, 168, 0.6);
    }

    button:active {
      transform: translateY(1px);
    }

    button::after {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background: linear-gradient(135deg, rgba(255,255,255,0.2) 0%, transparent 100%);
      transform: translateX(-100%);
      transition: transform 0.4s ease;
    }

    button:hover::after {
      transform: translateX(100%);
    }

    .quiz, .table { 
      max-width: 1000px; 
      margin: 30px auto; 
      text-align: center; 
      background: rgba(91, 33, 182, 0.2);
      backdrop-filter: blur(10px);
      padding: 30px; 
      border-radius: 20px;
      box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
      border: 1px solid rgba(255, 255, 255, 0.1);
    }

    .answers button { 
      display: block; 
      width: 100%; 
      text-align: left; 
      margin: 8px 0; 
      padding: 12px 20px; 
      border-radius: 10px; 
      border: none; 
      font-size: 16px; 
      background: rgba(109, 40, 217, 0.7);
      cursor: pointer; 
      transition: all 0.3s ease;
      position: relative;
      overflow: hidden;
    }

    .answers button:hover {
      background: rgba(109, 40, 217, 0.9);
      transform: translateX(5px);
    }

    .answers button::before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      width: 4px;
      height: 100%;
      background: #4f46e5;
      transform: scaleY(0);
      transition: transform 0.3s ease;
    }

    .answers button:hover::before {
      transform: scaleY(1);
    }

    .answers button.correct { 
      background: linear-gradient(135deg, #22c55e 0%, #10b981 100%);
    }

    .answers button.wrong { 
      background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
    }

    .element { 
      display: inline-block; 
      width: 60px; 
      height: 60px; 
      margin: 2px; 
      background: linear-gradient(135deg, #7e22ce 0%, #6b21a8 100%);
      border-radius: 8px; 
      text-align: center; 
      line-height: 60px; 
      cursor: pointer; 
      font-weight: bold; 
      transition: all 0.2s ease;
      box-shadow: 0 4px 8px rgba(0,0,0,0.2);
      position: relative;
      overflow: hidden;
    }

    .element:hover {
      transform: scale(1.05) rotate(2deg);
      box-shadow: 0 0 15px rgba(255,255,255,0.7);
      z-index: 10;
    }

    .element::after {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background: linear-gradient(135deg, rgba(255,255,255,0.2) 0%, transparent 100%);
      transform: translateX(-100%);
      transition: transform 0.4s ease;
    }

    .element:hover::after {
      transform: translateX(100%);
    }

    .element[data-category="alkali"] { background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%); }
    .element[data-category="alkaline"] { background: linear-gradient(135deg, #84cc16 0%, #65a30d 100%); }
    .element[data-category="transition"] { background: linear-gradient(135deg, #3b82f6 0%, #1d4ed8 100%); }
    .element[data-category="basic-metal"] { background: linear-gradient(135deg, #14b8a6 0%, #0d9488 100%); }
    .element[data-category="metalloid"] { background: linear-gradient(135deg, #8b5cf6 0%, #7c3aed 100%); }
    .element[data-category="nonmetal"] { background: linear-gradient(135deg, #ec4899 0%, #db2777 100%); }
    .element[data-category="halogen"] { background: linear-gradient(135deg, #f97316 0%, #ea580c 100%); }
    .element[data-category="noble"] { background: linear-gradient(135deg, #06b6d4 0%, #0891b2 100%); }
    .element[data-category="lanthanide"] { background: linear-gradient(135deg, #a855f7 0%, #9333ea 100%); }
    .element[data-category="actinide"] { background: linear-gradient(135deg, #e879f9 0%, #d946ef 100%); }

    .element.filtered-out {
      opacity: 0.3;
      transform: scale(0.9);
      pointer-events: none;
      filter: grayscale(70%);
    }

    .search-container {
      margin: 20px 0;
      position: relative;
    }

    #search {
      padding: 12px 20px;
      width: 100%;
      max-width: 400px;
      border-radius: 30px;
      border: 1px solid rgba(255,255,255,0.2);
      font-size: 16px;
      background: rgba(255,255,255,0.1);
      color: white;
      backdrop-filter: blur(5px);
      box-shadow: 0 4px 15px rgba(0,0,0,0.1);
      transition: all 0.3s ease;
    }

    #search:focus {
      outline: none;
      border-color: #6d28d9;
      box-shadow: 0 0 0 2px rgba(109, 40, 217, 0.5);
    }

    #search::placeholder {
      color: rgba(255,255,255,0.6);
    }

    .legend {
      display: flex;
      flex-wrap: wrap;
      justify-content: center;
      gap: 10px;
      margin: 20px 0;
      font-size: 0.9rem;
    }

    .legend div {
      display: flex;
      align-items: center;
      padding: 5px 10px;
      background: rgba(255,255,255,0.1);
      border-radius: 20px;
      cursor: pointer;
      transition: all 0.2s ease;
    }

    .legend div:hover {
      transform: scale(1.05);
      box-shadow: 0 0 10px rgba(255,255,255,0.3);
    }

    .legend div.active {
      background: rgba(255,255,255,0.3);
      box-shadow: 0 0 15px rgba(255,255,255,0.5);
    }

    .legend-color {
      display: inline-block;
      width: 15px;
      height: 15px;
      border-radius: 50%;
      margin-right: 8px;
    }

    .legend-color.alkali { background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%); }
    .legend-color.alkaline { background: linear-gradient(135deg, #84cc16 0%, #65a30d 100%); }
    .legend-color.transition { background: linear-gradient(135deg, #3b82f6 0%, #1d4ed8 100%); }
    .legend-color.basic-metal { background: linear-gradient(135deg, #14b8a6 0%, #0d9488 100%); }
    .legend-color.metalloid { background: linear-gradient(135deg, #8b5cf6 0%, #7c3aed 100%); }
    .legend-color.nonmetal { background: linear-gradient(135deg, #ec4899 0%, #db2777 100%); }
    .legend-color.halogen { background: linear-gradient(135deg, #f97316 0%, #ea580c 100%); }
    .legend-color.noble { background: linear-gradient(135deg, #06b6d4 0%, #0891b2 100%); }
    .legend-color.lanthanide { background: linear-gradient(135deg, #a855f7 0%, #9333ea 100%); }
    .legend-color.actinide { background: linear-gradient(135deg, #e879f9 0%, #d946ef 100%); }

    .element-fullscreen {
      position: fixed;
      top: 0; 
      left: 0;
      width: 100%; 
      height: 100%;
      background: linear-gradient(135deg, #3b0764 0%, #1e1b4b 100%);
      color: white;
      display: flex;
      flex-direction: column;
      align-items: center;
      padding: 40px;
      box-sizing: border-box;
      z-index: 999;
      overflow-y: auto;
      backdrop-filter: blur(10px);
    }

    .element-fullscreen img {
      max-height: 250px;
      border-radius: 12px;
      margin: 20px 0;
      box-shadow: 0 10px 30px rgba(0,0,0,0.5);
      border: 2px solid rgba(255,255,255,0.1);
    }

    .element-fullscreen .info {
      max-width: 800px;
      padding: 30px;
      text-align: left;
      background: rgba(0,0,0,0.2);
      border-radius: 15px;
      box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
      border: 1px solid rgba(255, 255, 255, 0.1);
    }

    .element-fullscreen h2 {
      font-size: 2.5rem;
      margin-bottom: 20px;
      color: #a78bfa;
      text-shadow: 0 0 10px rgba(167, 139, 250, 0.5);
    }

    .element-fullscreen p {
      margin-bottom: 15px;
      line-height: 1.6;
    }

    .element-fullscreen strong {
      color: #c4b5fd;
    }

    .image-container {
      position: relative;
      width: 250px;
      height: 250px;
      display: flex;
      justify-content: center;
      align-items: center;
    }

    .loading-spinner {
      width: 50px;
      height: 50px;
      border: 5px solid rgba(255,255,255,0.2);
      border-radius: 50%;
      border-top-color: #6d28d9;
      animation: spin 1s linear infinite;
    }

    @keyframes spin {
      100% { transform: rotate(360deg); }
    }

    .hidden { 
      display: none; 
    }

    .empty-cell {
      width: 60px;
      height: 60px;
      margin: 2px;
      visibility: hidden;
    }

    .lanthanide-actinide-row {
      margin-top: 10px;
    }

    #periodic-grid {
      display: inline-block;
      margin: 20px auto;
    }

    .periodic-row {
      display: flex;
      justify-content: center;
    }

    /* Atom visualization styles */
    .atom-visualization {
      width: 300px;
      height: 300px;
      margin: 20px auto;
      position: relative;
      border-radius: 50%;
      background: rgba(0,0,0,0.2);
      box-shadow: 0 0 30px rgba(167, 139, 250, 0.3);
    }

    .atom-nucleus {
      position: absolute;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%);
      width: 40px;
      height: 40px;
      border-radius: 50%;
      background: radial-gradient(circle at 30% 30%, #f87171, #dc2626);
      box-shadow: 0 0 20px #dc2626;
      display: flex;
      justify-content: center;
      align-items: center;
      color: white;
      font-weight: bold;
      font-size: 12px;
    }

    .atom-orbit {
      position: absolute;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%);
      border: 1px solid rgba(255,255,255,0.3);
      border-radius: 50%;
    }

    .atom-electron {
      position: absolute;
      width: 10px;
      height: 10px;
      border-radius: 50%;
      background: radial-gradient(circle at 30% 30%, #93c5fd, #3b82f6);
      box-shadow: 0 0 10px #3b82f6;
    }

    /* New styles for quiz explanations */
    .explanation-notification {
      position: fixed;
      bottom: 20px;
      right: 20px;
      background: rgba(0, 0, 0, 0.8);
      color: white;
      padding: 15px;
      border-radius: 10px;
      max-width: 300px;
      z-index: 1000;
      backdrop-filter: blur(5px);
      border: 1px solid rgba(255, 255, 255, 0.1);
      box-shadow: 0 4px 15px rgba(0, 0, 0, 0.3);
      transform: translateY(20px);
      opacity: 0;
      animation: notification-enter 0.3s forwards;
    }

    .notification-content {
      display: flex;
      align-items: center;
      gap: 10px;
    }

    .notification-icon {
      font-size: 24px;
      flex-shrink: 0;
    }

    .explanation-notification.fade-out {
      animation: notification-exit 0.3s forwards;
    }

    @keyframes notification-enter {
      from { transform: translateY(20px); opacity: 0; }
      to { transform: translateY(0); opacity: 1; }
    }

    @keyframes notification-exit {
      from { transform: translateY(0); opacity: 1; }
      to { transform: translateY(20px); opacity: 0; }
    }

    .explanation-button {
      background: none;
      border: none;
      color: #a78bfa;
      font-weight: bold;
      cursor: pointer;
      margin-left: 5px;
      font-size: 16px;
    }

    .explanation-button:hover {
      color: #6d28d9;
    }

    @media (max-width: 768px) {
      .container, .quiz, .table {
        padding: 20px;
        margin: 20px 10px;
      }
      
      .element {
        width: 10px;
        height: 10px;
        line-height: 40px;
        font-size: 12px;
      }
      
      .empty-cell {
        width: 40px;
        height: 40px;
      }
      
      .element-fullscreen {
        padding: 20px;
      }
      
      .element-fullscreen .info {
        padding: 15px;
      }
      
      .legend {
        gap: 5px;
        font-size: 0.8rem;
      }
      
      .legend div {
        padding: 3px 6px;
      }
      
      .legend-color {
        width: 12px;
        height: 12px;
      }
      
      .atom-visualization {
        width: 200px;
        height: 200px;
      }

      .explanation-notification {
        max-width: 250px;
        right: 10px;
        bottom: 10px;
      }
    }
  </style>
</head>
<body>
  <div class="science-header">
    <div class="molecule-animation">
      <div class="atom">
        <div class="nucleus"></div>
        <div class="orbit"></div>
        <div class="electron"></div>
        <div class="orbit"></div>
        <div class="electron"></div>
        <div class="orbit"></div>
        <div class="electron"></div>
      </div>
    </div>
    <h1>Chemistry Explorer</h1>
  </div>

  <div class="container">
    <img src="https://cdn-icons-png.flaticon.com/512/4712/4712027.png" alt="Robot" class="robot">
    <h2>Welcome to the Chemistry World</h2>
    <p>Explore chemistry through quizzes and the periodic table!</p>
    <button onclick="showSection('quiz')">Start Quiz</button>
    <button onclick="showSection('table')">Explore Periodic Table</button>
  </div>

  <div id="quiz" class="quiz hidden">
    <h2>Chemistry Quiz</h2>
    <label for="difficulty">Select Difficulty:</label>
    <select id="difficulty" onchange="setDifficulty(this.value)">
      <option value="easy">Easy</option>
      <option value="normal">Normal</option>
      <option value="hard">Hard</option>
      <option value="veryHard">Very Hard</option>
    </select>
    <p id="quiz-question"></p>
    <div class="answers" id="quiz-answers"></div>
    <button onclick="nextQuestion()">Next Question</button>
    <button onclick="goHome()">Back</button>
  </div>

  <div id="table" class="table hidden">
    <h2>Periodic Table</h2>
    <div class="search-container">
      <input type="text" id="search" oninput="searchElements()" placeholder="Search element...">
    </div>
    <div class="legend">
      <div onclick="filterByCategory('alkali')"><span class="legend-color alkali"></span> Alkali Metals</div>
      <div onclick="filterByCategory('alkaline')"><span class="legend-color alkaline"></span> Alkaline Earth</div>
      <div onclick="filterByCategory('transition')"><span class="legend-color transition"></span> Transition Metals</div>
      <div onclick="filterByCategory('basic-metal')"><span class="legend-color basic-metal"></span> Basic Metals</div>
      <div onclick="filterByCategory('metalloid')"><span class="legend-color metalloid"></span> Metalloids</div>
      <div onclick="filterByCategory('nonmetal')"><span class="legend-color nonmetal"></span> Nonmetals</div>
      <div onclick="filterByCategory('halogen')"><span class="legend-color halogen"></span> Halogens</div>
      <div onclick="filterByCategory('noble')"><span class="legend-color noble"></span> Noble Gases</div>
      <div onclick="filterByCategory('lanthanide')"><span class="legend-color lanthanide"></span> Lanthanides</div>
      <div onclick="filterByCategory('actinide')"><span class="legend-color actinide"></span> Actinides</div>
      <div onclick="clearFilters()"><span class="legend-color" style="background: white;"></span> Show All</div>
    </div>
    <div id="periodic-grid"></div>
    <button onclick="goHome()">Back</button>
  </div>

  <script>
    const quizData = {
      "easy": [
        {
          "question": "What is the chemical symbol for water?",
          "options": ["O₂", "CO₂", "NaCl", "H₂O"],
          "answer": "H₂O",
          "explanation": "Water is composed of two hydrogen atoms and one oxygen atom, hence the chemical formula H₂O."
        },
        {
          "question": "What is the atomic number of hydrogen?",
          "options": ["8", "1", "2", "10"],
          "answer": "1",
          "explanation": "Hydrogen is the first element in the periodic table, with one proton in its nucleus."
        },
        {
          "question": "Which gas do plants use for photosynthesis?",
          "options": ["Oxygen", "Carbon dioxide", "Nitrogen", "Hydrogen"],
          "answer": "Carbon dioxide",
          "explanation": "Plants take in carbon dioxide (CO₂) and release oxygen (O₂) during photosynthesis."
        },
        {
          "question": "What is the symbol for oxygen?",
          "options": ["Og", "Ox", "O", "Oz"],
          "answer": "O",
          "explanation": "The chemical symbol for oxygen is simply 'O', derived from its Latin name 'Oxygenium'."
        },
        {
          "question": "Which element is represented by 'Na'?",
          "options": ["Nickel", "Nitrogen", "Neon", "Sodium"],
          "answer": "Sodium",
          "explanation": "'Na' comes from the Latin name for sodium, 'Natrium'."
        },
        {
          "question": "What is H₂SO₄ commonly known as?",
          "options": ["Sulfuric acid", "Hydrochloric acid", "Nitric acid", "Acetic acid"],
          "answer": "Sulfuric acid",
          "explanation": "H₂SO₄ is the chemical formula for sulfuric acid, a strong mineral acid."
        },
        {
          "question": "Which element is a noble gas: Helium or Nitrogen?",
          "options": ["Helium", "Nitrogen", "Oxygen", "Hydrogen"],
          "answer": "Helium",
          "explanation": "Helium is a noble gas (Group 18), while nitrogen is a diatomic nonmetal (Group 15)."
        },
        {
          "question": "What does the pH scale measure?",
          "options": ["Mass", "Temperature", "Acidity or basicity", "Volume"],
          "answer": "Acidity or basicity",
          "explanation": "The pH scale measures how acidic or basic a solution is, ranging from 0 (acidic) to 14 (basic)."
        },
        {
          "question": "What is the main gas in the Earth's atmosphere?",
          "options": ["Nitrogen", "Oxygen", "Carbon Dioxide", "Argon"],
          "answer": "Nitrogen",
          "explanation": "Nitrogen makes up about 78% of Earth's atmosphere, while oxygen is about 21%."
        },
        {
          "question": "Which state of matter has a fixed shape and volume?",
          "options": ["Solid", "Liquid", "Gas", "Plasma"],
          "answer": "Solid",
          "explanation": "Solids have fixed shape and volume due to their tightly packed particles."
        }
      ],
      "normal": [
        {
          "question": "What is the chemical symbol for gold?",
          "options": ["Au", "Ag", "Gd", "Ga"],
          "answer": "Au",
          "explanation": "Gold's symbol 'Au' comes from its Latin name 'Aurum'."
        },
        {
          "question": "What are the three subatomic particles?",
          "options": ["Proton, Neutron, Electron", "Ion, Atom, Molecule", "Quark, Photon, Gluon", "Nucleus, Shell, Core"],
          "answer": "Proton, Neutron, Electron",
          "explanation": "Atoms are composed of protons (positive), neutrons (neutral), and electrons (negative)."
        },
        {
          "question": "What is the atomic number of carbon?",
          "options": ["10", "12", "8", "6"],
          "answer": "6",
          "explanation": "Carbon has 6 protons in its nucleus, giving it atomic number 6."
        },
        {
          "question": "Which acid is found in the stomach?",
          "options": ["Sulfurous acid", "Sulfuric acid", "Hydrochloric acid", "Acetic acid"],
          "answer": "Hydrochloric acid",
          "explanation": "The stomach secretes hydrochloric acid (HCl) to help digest food and kill bacteria."
        },
        {
          "question": "How many electrons can the first shell hold?",
          "options": ["8", "2", "4", "6"],
          "answer": "2",
          "explanation": "The first electron shell (n=1) can hold a maximum of 2 electrons."
        },
        {
          "question": "What is the molecular formula for methane?",
          "options": ["C₂H₄", "C₂H₆", "C₃H₈", "CH₄"],
          "answer": "CH₄",
          "explanation": "Methane is the simplest hydrocarbon, with one carbon atom bonded to four hydrogen atoms."
        },
        {
          "question": "What is the name for a horizontal row on the periodic table?",
          "options": ["Series", "Group", "Period", "Block"],
          "answer": "Period",
          "explanation": "Horizontal rows are called periods, while vertical columns are called groups."
        },
        {
          "question": "What is the charge on a neutron?",
          "options": ["-1", "+1", "0", "+2"],
          "answer": "0",
          "explanation": "Neutrons are neutral particles with no electrical charge."
        },
        {
          "question": "What is the law of conservation of mass?",
          "options": ["Mass is neither created nor destroyed", "Energy is conserved", "Matter can be changed to energy", "Atoms cannot be divided"],
          "answer": "Mass is neither created nor destroyed",
          "explanation": "In chemical reactions, the total mass of reactants equals the total mass of products."
        },
        {
          "question": "Which two elements are liquid at room temperature?",
          "options": ["Helium and Radon", "Mercury and Gallium", "Chlorine and Bromine", "Mercury and Bromine"],
          "answer": "Mercury and Bromine",
          "explanation": "Mercury (Hg) is a metal liquid at room temp, while bromine (Br) is a nonmetal liquid."
        }
      ],
      "hard": [
        {
          "question": "What is the oxidation state of sulfur in H₂SO₄?",
          "options": ["+4", "+6", "-2", "0"],
          "answer": "+6",
          "explanation": "In sulfuric acid, oxygen is -2 (total -8), hydrogen is +1 (total +2), so sulfur must be +6 to balance."
        },
        {
          "question": "How many valence electrons does phosphorus have?",
          "options": ["3", "5", "7", "1"],
          "answer": "5",
          "explanation": "Phosphorus is in Group 15, so it has 5 valence electrons."
        },
        {
          "question": "Name an element that exhibits allotropy.",
          "options": ["Carbon", "Neon", "Sodium", "Zinc"],
          "answer": "Carbon",
          "explanation": "Carbon has several allotropes including diamond, graphite, and fullerenes."
        },
        {
          "question": "Which law relates pressure and volume of a gas?",
          "options": ["Charles's Law", "Boyle's Law", "Avogadro's Law", "Newton's Law"],
          "answer": "Boyle's Law",
          "explanation": "Boyle's Law states that pressure and volume are inversely proportional at constant temperature."
        },
        {
          "question": "What is the hybridization of carbon in methane?",
          "options": ["dsp²", "sp²", "sp", "sp³"],
          "answer": "sp³",
          "explanation": "Carbon in methane forms four equivalent bonds, requiring sp³ hybridization."
        },
        {
          "question": "How does atomic radius change across a period?",
          "options": ["Stays the same", "Increases", "Decreases", "Doubles"],
          "answer": "Decreases",
          "explanation": "Atomic radius decreases across a period due to increasing nuclear charge pulling electrons closer."
        },
        {
          "question": "Which orbital has the highest energy in the 3rd period?",
          "options": ["3s", "3p", "3d", "2p"],
          "answer": "3d",
          "explanation": "3d orbitals are higher in energy than 3s and 3p in the 3rd period elements."
        },
        {
          "question": "What is the shape of an sp³ hybridized molecule?",
          "options": ["Tetrahedral", "Trigonal planar", "Linear", "Octahedral"],
          "answer": "Tetrahedral",
          "explanation": "sp³ hybridization results in tetrahedral geometry with ~109.5° bond angles."
        },
        {
          "question": "Define molar mass.",
          "options": ["Avogadro's number", "Mass of a single atom", "Molecular weight", "Mass of one mole of a substance"],
          "answer": "Mass of one mole of a substance",
          "explanation": "Molar mass is the mass (in grams) of one mole (6.022×10²³ particles) of a substance."
        },
        {
          "question": "What is the conjugate base of H₂SO₄?",
          "options": ["OH⁻", "SO₄²⁻", "HSO₄⁻", "H₃O⁺"],
          "answer": "HSO₄⁻",
          "explanation": "When H₂SO₄ loses one proton (H⁺), it forms the hydrogen sulfate ion HSO₄⁻."
        }
      ],
      "veryHard": [
        {
          "question": "What is the electron configuration of Cr³⁺?",
          "options": ["[Ar] 3d³", "[Ar] 3d⁵", "[Ar] 4s² 3d³", "[Ar] 3d⁶"],
          "answer": "[Ar] 3d³",
          "explanation": "Cr is [Ar] 4s¹ 3d⁵. Cr³⁺ loses the 4s and two 3d electrons, leaving [Ar] 3d³."
        },
        {
          "question": "What is the Schrodinger equation used for in chemistry?",
          "options": ["Measuring temperature", "Describing electron behavior", "Balancing equations", "Calculating moles"],
          "answer": "Describing electron behavior",
          "explanation": "The Schrödinger equation describes the quantum state of electrons in atoms and molecules."
        },
        {
          "question": "Explain the difference between kinetic and thermodynamic control.",
          "options": ["Thermodynamic is faster", "Thermodynamic is faster", "Kinetic is faster; thermodynamic is more stable", "They are identical"],
          "answer": "Kinetic is faster; thermodynamic is more stable",
          "explanation": "Kinetic products form faster but may be less stable; thermodynamic products are more stable but form slower."
        },
        {
          "question": "Derive the integrated rate law for a second-order reaction.",
          "options": ["1/[A]² = kt + 1/[A]₀²", "ln[A] = -kt + ln[A]₀", "1/[A] = kt + 1/[A]₀", "1/[A] = kt + 1/[A]₀"],
          "answer": "1/[A] = kt + 1/[A]₀",
          "explanation": "For a second-order reaction with one reactant, the integrated rate law is 1/[A] = kt + 1/[A]₀."
        },
        {
          "question": "What is the difference between orbital and subshell?",
          "options": ["Subshell is within orbital", "Orbital is within subshell", "They are same", "Orbitals contain multiple subshells"],
          "answer": "Orbital is within subshell",
          "explanation": "A subshell (s,p,d,f) contains orbitals. Each orbital can hold 2 electrons."
        },
        {
          "question": "Predict the geometry of SF₄ using VSEPR theory.",
          "options": ["Tetrahedral", "Seesaw", "Trigonal bipyramidal", "Octahedral"],
          "answer": "Seesaw",
          "explanation": "SF₄ has 5 electron domains (4 bonds + 1 lone pair), resulting in seesaw molecular geometry."
        },
        {
          "question": "What is the Born-Haber cycle?",
          "options": ["Electric potential equation", "Energy diagram for reactions", "Cycle for gases", "Thermodynamic cycle for lattice energy"],
          "answer": "Thermodynamic cycle for lattice energy",
          "explanation": "The Born-Haber cycle calculates lattice energy from other thermodynamic quantities."
        },
        {
          "question": "Define the crystal field splitting in octahedral complexes.",
          "options": ["Bond energy change", "Splitting of p orbitals", "Separation of d orbitals into t₂g and eg", "Electron configuration rule"],
          "answer": "Separation of d orbitals into t₂g and eg",
          "explanation": "In octahedral fields, d orbitals split into lower-energy t₂g and higher-energy eg sets."
        },
        {
          "question": "Explain the concept of aromaticity using Huckel's Rule.",
          "options": ["4n+2 π electrons in cyclic, planar system", "Must be non-polar", "High boiling point", "Strong acid"],
          "answer": "4n+2 π electrons in cyclic, planar system",
          "explanation": "Hückel's Rule states aromatic compounds have (4n+2) π electrons in a conjugated, planar ring."
        },
        {
          "question": "What is the Nernst equation used for?",
          "options": ["Calculating cell potential", "Mass balance", "Gas law", "Electron configuration"],
          "answer": "Calculating cell potential",
          "explanation": "The Nernst equation relates cell potential to concentration: E = E° - (RT/nF)lnQ."
        }
      ]
    };
// Periodic Table Data
    const elements = [
      {
        "symbol": "H",
        "name": "Hydrogen",
        "number": 1,
        "mass": "1.008",
        "discovery": "Henry Cavendish (1766)",
        "foundInSpace": "Yes",
        "uses": "Fuel, ammonia production, hydrogenation of fats",
        "price": "0.0001 USD/g",
        "story": "Hydrogen was first recognized as a distinct substance in 1766 by Henry Cavendish.",
        "image": "crabnebula-57e1baaa3df78c9cce3394a6.webp",
        "electrons": [1],
        "protons": 1,
        "neutrons": 0
      },
      {
        "symbol": "He",
        "name": "Helium",
        "number": 2,
        "mass": "4.0026",
        "discovery": "Pierre Janssen, Norman Lockyer (1868)",
        "foundInSpace": "Yes",
        "uses": "Cryogenics, airships, MRI scanners",
        "price": "0.005 USD/g",
        "story": "Helium was first detected during a solar eclipse in 1868 as a yellow spectral line.",
        "image": "2_Helium-liquid-58b5e4235f9b586046ff4121.webp",
        "electrons": [2],
        "protons": 2,
        "neutrons": 2
      },
      {
        "symbol": "Li",
        "name": "Lithium",
        "number": 3,
        "mass": "6.94",
        "discovery": "Johan August Arfwedson (1817)",
        "foundInSpace": "Yes",
        "uses": "Batteries, mood stabilizer, alloys",
        "price": "0.01 USD/g",
        "story": "Lithium was discovered from mineral samples by Johan August Arfwedson in 1817.",
        "image": "Lithium_element-58b5e41f5f9b586046ff360e.webp",
        "electrons": [2, 1],
        "protons": 3,
        "neutrons": 4
      },
      {
        "symbol": "Be",
        "name": "Beryllium",
        "number": 4,
        "mass": "9.0122",
        "discovery": "Louis Nicolas Vauquelin (1798)",
        "foundInSpace": "Yes",
        "uses": "X-ray windows, spacecraft, alloys",
        "price": "0.05 USD/g",
        "story": "Beryllium was discovered by Louis Nicolas Vauquelin in 1798 as a component of beryl and emeralds.",
        "image": "chinese-folding-glasses-with-beryllium-lenses-china-mid-18th-century-530024911-58b5e4183df78cdcd8efebb7.webp",
        "electrons": [2, 2],
        "protons": 4,
        "neutrons": 5
      },
      {
        "symbol": "B",
        "name": "Boron",
        "number": 5,
        "mass": "10.81",
        "discovery": "Joseph Louis Gay-Lussac, Louis Jacques Thénard (1808)",
        "foundInSpace": "Yes",
        "uses": "Fiberglass, detergents, semiconductors",
        "price": "0.02 USD/g",
        "story": "Boron was first partially purified by Sir Humphry Davy and then isolated by Gay-Lussac and Thénard in 1808.",
        "image": "Boron_R105-58b5e4113df78cdcd8efd42e.webp",
        "electrons": [2, 3],
        "protons": 5,
        "neutrons": 6
      },
      {
        "symbol": "C",
        "name": "Carbon",
        "number": 6,
        "mass": "12.011",
        "discovery": "Ancient times",
        "foundInSpace": "Yes",
        "uses": "Life, fuels, steel production",
        "price": "0.001 USD/g",
        "story": "Carbon has been known since ancient times in the form of soot, charcoal, and diamonds.",
        "image": "forms-of-carbon-including-a-coal-charcoal-graphite-and-diamonds-76128281-58b5e4093df78cdcd8efbbf0.webp",
        "electrons": [2, 4],
        "protons": 6,
        "neutrons": 6
      },
      {
        "symbol": "N",
        "name": "Nitrogen",
        "number": 7,
        "mass": "14.007",
        "discovery": "Daniel Rutherford (1772)",
        "foundInSpace": "Yes",
        "uses": "Fertilizers, explosives, ammonia",
        "price": "0.0002 USD/g",
        "story": "Nitrogen was discovered by Scottish physician Daniel Rutherford in 1772.",
        "image": "nitrogen-glow-58b5dcab5f9b586046ea0671.webp",
        "electrons": [2, 5],
        "protons": 7,
        "neutrons": 7
      },
      {
        "symbol": "O",
        "name": "Oxygen",
        "number": 8,
        "mass": "15.999",
        "discovery": "Carl Wilhelm Scheele, Joseph Priestley (1771-1774)",
        "foundInSpace": "Yes",
        "uses": "Respiration, combustion, water",
        "price": "0.0003 USD/g",
        "story": "images.jpeg",
        "image": "images/Oxygen.jpeg",
        "electrons": [2, 6],
        "protons": 8,
        "neutrons": 8
      },
      {
        "symbol": "F",
        "name": "Fluorine",
        "number": 9,
        "mass": "18.998",
        "discovery": "Henri Moissan (1886)",
        "foundInSpace": "Yes",
        "uses": "Toothpaste, refrigerants, uranium processing",
        "price": "0.0005 USD/g",
        "story": "Fluorine was isolated by Henri Moissan in 1886 after many failed attempts by other chemists.",
        "image": "Liquid_fluorine_tighter_crop-58b5e3f73df78cdcd8ef869d.webp",
        "electrons": [2, 7],
        "protons": 9,
        "neutrons": 10
      },
      {
        "symbol": "Ne",
        "name": "Neon",
        "number": 10,
        "mass": "20.180",
        "discovery": "William Ramsay, Morris Travers (1898)",
        "foundInSpace": "Yes",
        "uses": "Lighting, lasers, cryogenics",
        "price": "0.0004 USD/g",
        "story": "Neon was discovered in 1898 by William Ramsay and Morris Travers as a component of liquefied air.",
        "image": "Neon-glow-58b5e2333df78cdcd8ea1954.webp",
        "electrons": [2, 8],
        "protons": 10,
        "neutrons": 10
      },
      // Elements 11-20 (Sodium to Calcium)
      {
        "symbol": "Na",
        "name": "Sodium",
        "number": 11,
        "mass": "22.990",
        "discovery": "Humphry Davy (1807)",
        "foundInSpace": "Yes",
        "uses": "Table salt, street lights, soap",
        "price": "0.0001 USD/g",
        "story": "Sodium was first isolated by Humphry Davy in 1807 through the electrolysis of sodium hydroxide.",
        "image": "sodiummetal-58b5b3c43df78cdcd8ae6517.webp",
        "electrons": [2, 8, 1],
        "protons": 11,
        "neutrons": 12
      },
      {
        "symbol": "Mg",
        "name": "Magnesium",
        "number": 12,
        "mass": "24.305",
        "discovery": "Joseph Black (1755), isolated by Humphry Davy (1808)",
        "foundInSpace": "Yes",
        "uses": "Alloys, flares, chlorophyll",
        "price": "0.0002 USD/g",
        "story": "Magnesium was first recognized as an element by Joseph Black in 1755 and isolated by Humphry Davy in 1808.",
        "image": "magnesium-58b5b3ba5f9b586046bd6f0f.webp",
        "electrons": [2, 8, 2],
        "protons": 12,
        "neutrons": 12
      },
      {
        "symbol": "Al",
        "name": "Aluminum",
        "number": 13,
        "mass": "26.982",
        "discovery": "Hans Christian Ørsted (1825)",
        "foundInSpace": "Yes",
        "uses": "Cans, aircraft, construction",
        "price": "0.0003 USD/g",
        "story": "Aluminum was first isolated by Hans Christian Ørsted in 1825 and became widely used after the Hall-Héroult process was developed.",
        "image": "magnesium-58b5b3ba5f9b586046bd6f0f.webp",
        "electrons": [2, 8, 3],
        "protons": 13,
        "neutrons": 14
      },
      {
        "symbol": "Si",
        "name": "Silicon",
        "number": 14,
        "mass": "28.085",
        "discovery": "Jöns Jacob Berzelius (1824)",
        "foundInSpace": "Yes",
        "uses": "Electronics, solar cells, glass",
        "price": "0.0004 USD/g",
        "story": "Silicon was discovered by Jöns Jacob Berzelius in 1824 and is the second most abundant element in Earth's crust.",
        "image": "silicon-58b5e3d95f9b586046fe63cc.webp",
        "electrons": [2, 8, 4],
        "protons": 14,
        "neutrons": 14
      },
      {
        "symbol": "P",
        "name": "Phosphorus",
        "number": 15,
        "mass": "30.974",
        "discovery": "Hennig Brand (1669)",
        "foundInSpace": "Yes",
        "uses": "Fertilizers, matches, DNA",
        "price": "0.0006 USD/g",
        "story": "Phosphorus was discovered by Hennig Brand in 1669 through the distillation of urine.",
        "image": "phosphorus_allotropes-58b5dc9c3df78cdcd8da9840 (1).webp",
        "electrons": [2, 8, 5],
        "protons": 15,
        "neutrons": 16
      },
      {
        "symbol": "S",
        "name": "Sulfur",
        "number": 16,
        "mass": "32.06",
        "discovery": "Ancient times",
        "foundInSpace": "Yes",
        "uses": "Gunpowder, rubber, fertilizers",
        "price": "0.0002 USD/g",
        "story": "Sulfur has been known since ancient times and is mentioned in the Bible as brimstone.",
        "image": "close-up-of-sulphur-73685364-58b5e3ce3df78cdcd8ef0cf0.webp",
        "electrons": [2, 8, 6],
        "protons": 16,
        "neutrons": 16
      },
      {
        "symbol": "Cl",
        "name": "Chlorine",
        "number": 17,
        "mass": "35.45",
        "discovery": "Carl Wilhelm Scheele (1774)",
        "foundInSpace": "Yes",
        "uses": "Water purification, PVC, disinfectants",
        "price": "0.0007 USD/g",
        "story": "Chlorine was discovered by Carl Wilhelm Scheele in 1774 but named by Humphry Davy in 1810.",
        "image": "test-tube-of-chlorine-condensed-into-liquid-by-dipping-into-jug-of-dry-ice-83189284-58b5e3c33df78cdcd8eeeb53.webp",
        "electrons": [2, 8, 7],
        "protons": 17,
        "neutrons": 18
      },
      {
        "symbol": "Ar",
        "name": "Argon",
        "number": 18,
        "mass": "39.948",
        "discovery": "Lord Rayleigh, William Ramsay (1894)",
        "foundInSpace": "Yes",
        "uses": "Lighting, welding, inert atmosphere",
        "price": "0.0008 USD/g",
        "story": "Argon was discovered in 1894 by Lord Rayleigh and William Ramsay as a component of air.",
        "image": "argonice-58b44b6c5f9b586046e57c02.webp",
        "electrons": [2, 8, 8],
        "protons": 18,
        "neutrons": 22
      },
      {
        "symbol": "K",
        "name": "Potassium",
        "number": 19,
        "mass": "39.098",
        "discovery": "Humphry Davy (1807)",
        "foundInSpace": "Yes",
        "uses": "Fertilizers, soaps, nerve function",
        "price": "0.0009 USD/g",
        "story": "Potassium was first isolated by Humphry Davy in 1807 using electrolysis.",
        "image": "81992232-58b5e3b45f9b586046fdf21a.webp",
        "electrons": [2, 8, 8, 1],
        "protons": 19,
        "neutrons": 20
      },
      {
        "symbol": "Ca",
        "name": "Calcium",
        "number": 20,
        "mass": "40.078",
        "discovery": "Humphry Davy (1808)",
        "foundInSpace": "Yes",
        "uses": "Bones, cement, antacids",
        "price": "0.0010 USD/g",
        "story": "Calcium was isolated by Humphry Davy in 1808 through the electrolysis of a mixture of lime and mercuric oxide.",
        "image": "81992232-58b5e3b45f9b586046fdf21a.webp",
        "electrons": [2, 8, 8, 2],
        "protons": 20,
        "neutrons": 20
      },
      // Elements 21-30 (Scandium to Zinc)
      {
        "symbol": "Sc",
        "name": "Scandium",
        "number": 21,
        "mass": "44.956",
        "discovery": "Lars Fredrik Nilson (1879)",
        "foundInSpace": "Yes",
        "uses": "Aerospace, sports equipment, lighting",
        "price": "0.0020 USD/g",
        "story": "Scandium was discovered by Lars Fredrik Nilson in 1879 while studying the minerals euxenite and gadolinite.",
        "image": "Scandium_sublimed_dendritic_and_1cm3_cube-58b5e3a63df78cdcd8ee910f.webp",
        "electrons": [2, 8, 9, 2],
        "protons": 21,
        "neutrons": 24
      },
      {
        "symbol": "Ti",
        "name": "Titanium",
        "number": 22,
        "mass": "47.867",
        "discovery": "William Gregor (1791)",
        "foundInSpace": "Yes",
        "uses": "Aircraft, paint, medical implants",
        "price": "0.0015 USD/g",
        "story": "Titanium was discovered by William Gregor in 1791 and named by Martin Heinrich Klaproth after the Titans of Greek mythology.",
        "image": "titanium-crystals-58b5e39b3df78cdcd8ee6b67.webp",
        "electrons": [2, 8, 10, 2],
        "protons": 22,
        "neutrons": 26
      },
      {
        "symbol": "V",
        "name": "Vanadium",
        "number": 23,
        "mass": "50.942",
        "discovery": "Andrés Manuel del Río (1801)",
        "foundInSpace": "Yes",
        "uses": "Steel alloys, catalysts, batteries",
        "price": "0.0012 USD/g",
        "story": "Vanadium was discovered by Andrés Manuel del Río in 1801 but rediscovered by Nils Gabriel Sefström in 1830.",
        "image": "1024px-Vanadium_crystal_bar_and_1cm3_cube-58b5e3915f9b586046fd8449.webp",
        "electrons": [2, 8, 11, 2],
        "protons": 23,
        "neutrons": 28
      },
      {
        "symbol": "Cr",
        "name": "Chromium",
        "number": 24,
        "mass": "51.996",
        "discovery": "Louis Nicolas Vauquelin (1797)",
        "foundInSpace": "Yes",
        "uses": "Stainless steel, chrome plating, pigments",
        "price": "0.0013 USD/g",
        "story": "Chromium was discovered by Louis Nicolas Vauquelin in 1797 while analyzing a Siberian red lead ore.",
        "image": "Chromium_crystals_cube-58b5c2293df78cdcd8b9d1dc.webp",
        "electrons": [2, 8, 13, 1],
        "protons": 24,
        "neutrons": 28
      },
      {
        "symbol": "Mn",
        "name": "Manganese",
        "number": 25,
        "mass": "54.938",
        "discovery": "Johan Gottlieb Gahn (1774)",
        "foundInSpace": "Yes",
        "uses": "Steel production, batteries, glass coloring",
        "price": "0.0011 USD/g",
        "story": "Manganese was isolated by Johan Gottlieb Gahn in 1774 by reducing manganese dioxide with carbon.",
        "image": "man-holds-handful-of-manganese-531114326-58b5e3813df78cdcd8ee1979.webp",
        "electrons": [2, 8, 13, 2],
        "protons": 25,
        "neutrons": 30
      },
      {
        "symbol": "Fe",
        "name": "Iron",
        "number": 26,
        "mass": "55.845",
        "discovery": "Ancient times",
        "foundInSpace": "Yes",
        "uses": "Steel, magnets, hemoglobin",
        "price": "0.0005 USD/g",
        "story": "Iron has been used since ancient times, with the Iron Age beginning around 1200 BCE.",
        "image": "iron-58b5c6d15f9b586046cacc06.webp",
        "electrons": [2, 8, 14, 2],
        "protons": 26,
        "neutrons": 30
      },
      {
        "symbol": "Co",
        "name": "Cobalt",
        "number": 27,
        "mass": "58.933",
        "discovery": "Georg Brandt (1735)",
        "foundInSpace": "Yes",
        "uses": "Magnets, pigments, vitamin B12",
        "price": "0.0014 USD/g",
        "story": "Cobalt was discovered by Georg Brandt in 1735 while studying minerals that gave glass a blue color.",
        "image": "cobalt-58b5e3753df78cdcd8edf5e0.webp",
        "electrons": [2, 8, 15, 2],
        "protons": 27,
        "neutrons": 32
      },
      {
        "symbol": "Ni",
        "name": "Nickel",
        "number": 28,
        "mass": "58.693",
        "discovery": "Axel Fredrik Cronstedt (1751)",
        "foundInSpace": "Yes",
        "uses": "Stainless steel, coins, batteries",
        "price": "0.0016 USD/g",
        "story": "Nickel was discovered by Axel Fredrik Cronstedt in 1751 when he mistook a nickel mineral for a copper mineral.",
        "image": "mineral-specimens-481531581-58b5e36f3df78cdcd8ede048.webp",
        "electrons": [2, 8, 16, 2],
        "protons": 28,
        "neutrons": 31
      },
      {
        "symbol": "Cu",
        "name": "Copper",
        "number": 29,
        "mass": "63.546",
        "discovery": "Ancient times",
        "foundInSpace": "Yes",
        "uses": "Electrical wiring, plumbing, coins",
        "price": "0.0025 USD/g",
        "story": "Copper has been used since prehistoric times, with the Copper Age beginning around 5000 BCE.",
        "image": "native-copper-bolivia-south-america-128068306-58b5e3663df78cdcd8edc232.webp",
        "electrons": [2, 8, 18, 1],
        "protons": 29,
        "neutrons": 35
      },
      {
        "symbol": "Zn",
        "name": "Zinc",
        "number": 30,
        "mass": "65.38",
        "discovery": "Andreas Marggraf (1746)",
        "foundInSpace": "Yes",
        "uses": "Galvanization, brass, sunscreen",
        "price": "0.0030 USD/g",
        "story": "Zinc was recognized as a distinct metal in India by 1000 BCE and isolated in Europe by Andreas Marggraf in 1746.",
        "image": "zinc-mine-nugget-155360569-58b5e35e5f9b586046fce53e.webp",
        "electrons": [2, 8, 18, 2],
        "protons": 30,
        "neutrons": 35
      },
      // Elements 31-40 (Gallium to Zirconium)
      {
        "symbol": "Ga",
        "name": "Gallium",
        "number": 31,
        "mass": "69.723",
        "discovery": "Paul-Émile Lecoq de Boisbaudran (1875)",
        "foundInSpace": "Yes",
        "uses": "Semiconductors, LEDs, thermometers",
        "price": "0.0040 USD/g",
        "story": "Gallium was discovered by Paul-Émile Lecoq de Boisbaudran in 1875 and named after Gallia (Latin for France).",
        "image": "gallium-58b5e3573df78cdcd8ed93e0.webp",
        "electrons": [2, 8, 18, 3],
        "protons": 31,
        "neutrons": 39
      },
      {
        "symbol": "Ge",
        "name": "Germanium",
        "number": 32,
        "mass": "72.630",
        "discovery": "Clemens Winkler (1886)",
        "foundInSpace": "Yes",
        "uses": "Semiconductors, fiber optics, infrared optics",
        "price": "0.0050 USD/g",
        "story": "Germanium was predicted by Mendeleev in 1871 as 'ekasilicon' and discovered by Clemens Winkler in 1886.",
        "image": "germanium-58b5e3543df78cdcd8ed87f2.webp",
        "electrons": [2, 8, 18, 4],
        "protons": 32,
        "neutrons": 41
      },
      {
        "symbol": "As",
        "name": "Arsenic",
        "number": 33,
        "mass": "74.922",
        "discovery": "Albertus Magnus (1250)",
        "foundInSpace": "Yes",
        "uses": "Semiconductors, pesticides, wood preservatives",
        "price": "0.0060 USD/g",
        "story": "Arsenic was known to ancient civilizations and identified as an element by Albertus Magnus around 1250.",
        "image": "arsenic-75375793-58b5e34e5f9b586046fcb38b.webp",
        "electrons": [2, 8, 18, 5],
        "protons": 33,
        "neutrons": 42
      },
      {
        "symbol": "Se",
        "name": "Selenium",
        "number": 34,
        "mass": "78.971",
        "discovery": "Jöns Jacob Berzelius (1817)",
        "foundInSpace": "Yes",
        "uses": "Photocopiers, solar cells, glass",
        "price": "0.0070 USD/g",
        "story": "Selenium was discovered by Jöns Jacob Berzelius in 1817 while analyzing impurities in sulfuric acid.",
        "image": "selenium-58b5e3455f9b586046fc92c1.webp",
        "electrons": [2, 8, 18, 6],
        "protons": 34,
        "neutrons": 45
      },
      {
        "symbol": "Br",
        "name": "Bromine",
        "number": 35,
        "mass": "79.904",
        "discovery": "Antoine Jérôme Balard (1826)",
        "foundInSpace": "Yes",
        "uses": "Flame retardants, photography, water purification",
        "price": "0.0080 USD/g",
        "story": "Bromine was discovered by Antoine Jérôme Balard in 1826 from seaweed ash.",
        "image": "Bromine-58b5e3405f9b586046fc83d4.webp",
        "electrons": [2, 8, 18, 7],
        "protons": 35,
        "neutrons": 45
      },
      {
        "symbol": "Kr",
        "name": "Krypton",
        "number": 36,
        "mass": "83.798",
        "discovery": "William Ramsay, Morris Travers (1898)",
        "foundInSpace": "Yes",
        "uses": "Lighting, photography, lasers",
        "price": "0.0090 USD/g",
        "story": "Krypton was discovered by William Ramsay and Morris Travers in 1898 as a component of liquefied air.",
        "image": "Krypton_discharge_tube-58b5e3393df78cdcd8ed314b.webp",
        "electrons": [2, 8, 18, 8],
        "protons": 36,
        "neutrons": 48
      },
      {
        "symbol": "Rb",
        "name": "Rubidium",
        "number": 37,
        "mass": "85.468",
        "discovery": "Robert Bunsen, Gustav Kirchhoff (1861)",
        "foundInSpace": "Yes",
        "uses": "Atomic clocks, photocells, fireworks",
        "price": "0.0100 USD/g",
        "story": "Rubidium was discovered by Robert Bunsen and Gustav Kirchhoff in 1861 using spectroscopy.",
        "image": "rubidium-58b5e3313df78cdcd8ed1ab0.webp",
        "electrons": [2, 8, 18, 8, 1],
        "protons": 37,
        "neutrons": 48
      },
      {
        "symbol": "Sr",
        "name": "Strontium",
        "number": 38,
        "mass": "87.62",
        "discovery": "William Cruickshank, Adair Crawford (1790)",
        "foundInSpace": "Yes",
        "uses": "Fireworks, flares, toothpaste for sensitive teeth",
        "price": "0.0110 USD/g",
        "story": "Strontium was discovered in 1790 by William Cruickshank and Adair Crawford in a mineral from Strontian, Scotland.",
        "image": "Strontium_destilled_crystals-58b5e3275f9b586046fc39db.webp",
        "electrons": [2, 8, 18, 8, 2],
        "protons": 38,
        "neutrons": 50
      },
      {
        "symbol": "Y",
        "name": "Yttrium",
        "number": 39,
        "mass": "88.906",
        "discovery": "Johan Gadolin (1794)",
        "foundInSpace": "Yes",
        "uses": "TV screens, LEDs, superconductors",
        "price": "0.0120 USD/g",
        "story": "Yttrium was discovered by Johan Gadolin in 1794 and named after the village of Ytterby in Sweden.",
        "image": "yttrium-dendrites-cube-58b5e31c3df78cdcd8ecd911.webp",
        "electrons": [2, 8, 18, 9, 2],
        "protons": 39,
        "neutrons": 50
      },
      {
        "symbol": "Zr",
        "name": "Zirconium",
        "number": 40,
        "mass": "91.224",
        "discovery": "Martin Heinrich Klaproth (1789)",
        "foundInSpace": "Yes",
        "uses": "Nuclear reactors, jewelry, ceramics",
        "price": "0.0130 USD/g",
        "story": "Zirconium was discovered by Martin Heinrich Klaproth in 1789 from the mineral zircon.",
        "image": "zicronium-crystals-cube-58b5e3185f9b586046fc0c84.webp",
        "electrons": [2, 8, 18, 10, 2],
        "protons": 40,
        "neutrons": 51
      },
      // Elements 41-50 (Niobium to Tin)
      {
        "symbol": "Nb",
        "name": "Niobium",
        "number": 41,
        "mass": "92.906",
        "discovery": "Charles Hatchett (1801)",
        "foundInSpace": "Yes",
        "uses": "Superconductors, jet engines, jewelry",
        "price": "0.0140 USD/g",
        "story": "Niobium was discovered by Charles Hatchett in 1801 and originally called columbium.",
        "image": "niobium-crystals-cube-58b5e3155f9b586046fc01d0.webp",
        "electrons": [2, 8, 18, 12, 1],
        "protons": 41,
        "neutrons": 52
      },
      {
        "symbol": "Mo",
        "name": "Molybdenum",
        "number": 42,
        "mass": "95.95",
        "discovery": "Carl Wilhelm Scheele (1778)",
        "foundInSpace": "Yes",
        "uses": "Steel alloys, lubricants, catalysts",
        "price": "0.0150 USD/g",
        "story": "Molybdenum was discovered by Carl Wilhelm Scheele in 1778 and isolated by Peter Jacob Hjelm in 1781.",
        "image": "molybdenum-crystal-cube-58b5e30f5f9b586046fbf20d.webp",
        "electrons": [2, 8, 18, 13, 1],
        "protons": 42,
        "neutrons": 54
      },
      {
        "symbol": "Tc",
        "name": "Technetium",
        "number": 43,
        "mass": "98",
        "discovery": "Carlo Perrier, Emilio Segrè (1937)",
        "foundInSpace": "Yes (in stars)",
        "uses": "Medical imaging, corrosion prevention",
        "price": "0.0160 USD/g",
        "story": "Technetium was the first artificially produced element, created in 1937 by Carlo Perrier and Emilio Segrè.",
        "image": "download.jpeg",
        "electrons": [2, 8, 18, 13, 2],
        "protons": 43,
        "neutrons": 55
      },
      {
        "symbol": "Ru",
        "name": "Ruthenium",
        "number": 44,
        "mass": "101.07",
        "discovery": "Karl Ernst Claus (1844)",
        "foundInSpace": "Yes",
        "uses": "Electronics, jewelry, catalysts",
        "price": "0.0170 USD/g",
        "story": "Ruthenium was discovered by Karl Ernst Claus in 1844 and named after Ruthenia (Latin for Russia).",
        "image": "Ruthenium_crystals-58b5e3063df78cdcd8ec9650.webp",
        "electrons": [2, 8, 18, 15, 1],
        "protons": 44,
        "neutrons": 57
      },
      {
        "symbol": "Rh",
        "name": "Rhodium",
        "number": 45,
        "mass": "102.91",
        "discovery": "William Hyde Wollaston (1803)",
        "foundInSpace": "Yes",
        "uses": "Catalytic converters, jewelry, electrical contacts",
        "price": "0.0180 USD/g",
        "story": "Rhodium was discovered by William Hyde Wollaston in 1803 soon after he discovered palladium.",
        "image": "Rhodium_powder_pressed_melted-58b5e3005f9b586046fbc47a.webp",
        "electrons": [2, 8, 18, 16, 1],
        "protons": 45,
        "neutrons": 58
      },
      {
        "symbol": "Pd",
        "name": "Palladium",
        "number": 46,
        "mass": "106.42",
        "discovery": "William Hyde Wollaston (1803)",
        "foundInSpace": "Yes",
        "uses": "Catalytic converters, jewelry, dentistry",
        "price": "0.0190 USD/g",
        "story": "Palladium was discovered by William Hyde Wollaston in 1803 and named after the asteroid Pallas.",
        "image": "download (1).jpeg",
        "electrons": [2, 8, 18, 18],
        "protons": 46,
        "neutrons": 60
      },
      {
        "symbol": "Ag",
        "name": "Silver",
        "number": 47,
        "mass": "107.87",
        "discovery": "Ancient times",
        "foundInSpace": "Yes",
        "uses": "Jewelry, photography, electronics",
        "price": "0.0200 USD/g",
        "story": "Silver has been known since ancient times and was one of the first five metals to be discovered.",
        "image": "raw-silver-crystal-98955646-58b5e2f63df78cdcd8ec64d0.webp",
        "electrons": [2, 8, 18, 18, 1],
        "protons": 47,
        "neutrons": 61
      },
      {
        "symbol": "Cd",
        "name": "Cadmium",
        "number": 48,
        "mass": "112.41",
        "discovery": "Karl Samuel Leberecht Hermann, Friedrich Stromeyer (1817)",
        "foundInSpace": "Yes",
        "uses": "Batteries, pigments, nuclear reactors",
        "price": "0.0004 USD/g",
        "story": "Cadmium was discovered in 1817 by Karl Samuel Leberecht Hermann and Friedrich Stromeyer as an impurity in zinc carbonate.",
        "image": "Cadmium-crystal_bar-58b5e2ea5f9b586046fb7f9a.webp",
        "electrons": [2, 8, 18, 18, 2],
        "protons": 48,
        "neutrons": 64
      },
      {
        "symbol": "In",
        "name": "Indium",
        "number": 49,
        "mass": "114.82",
        "discovery": "Ferdinand Reich, Hieronymous Theodor Richter (1863)",
        "foundInSpace": "Yes",
        "uses": "LCD screens, solders, semiconductors",
        "price": "0.0003 USD/g",
        "story": "Indium was discovered in 1863 by Ferdinand Reich and Hieronymous Theodor Richter through spectroscopic analysis.",
        "image": "Indium-58b5c2195f9b586046c8f349.webp",
        "electrons": [2, 8, 18, 18, 3],
        "protons": 49,
        "neutrons": 66
      },
      {
        "symbol": "Sn",
        "name": "Tin",
        "number": 50,
        "mass": "118.71",
        "discovery": "Ancient times",
        "foundInSpace": "Yes",
        "uses": "Cans, solder, bronze",
        "price": "0.0006 USD/g",
        "story": "Tin has been known since ancient times and was crucial to the development of bronze (tin + copper).",
        "image": "Sn-Alpha-Beta-58b5e2db5f9b586046fb519f.webp",
        "electrons": [2, 8, 18, 18, 4],
        "protons": 50,
        "neutrons": 69
      },
      // Elements 51-60 (Antimony to Neodymium)
      {
        "symbol": "Sb",
        "name": "Antimony",
        "number": 51,
        "mass": "121.76",
        "discovery": "Ancient times",
        "foundInSpace": "Yes",
        "uses": "Flame retardants, batteries, alloys",
        "price": "0.0005 USD/g",
        "story": "Antimony has been known since ancient times and was used in cosmetics and medicines.",
        "image": "download (2).jpeg",
        "electrons": [2, 8, 18, 18, 5],
        "protons": 51,
        "neutrons": 71
      },
      {
        "symbol": "Te",
        "name": "Tellurium",
        "number": 52,
        "mass": "127.60",
        "discovery": "Franz-Joseph Müller von Reichenstein (1782)",
        "foundInSpace": "Yes",
        "uses": "Solar panels, alloys, rubber",
        "price": "0.0006 USD/g",
        "story": "Tellurium was discovered in 1782 by Franz-Joseph Müller von Reichenstein in gold ores.",
        "image": "Tellurium2-58b5e2d65f9b586046fb416a.webp",
        "electrons": [2, 8, 18, 18, 6],
        "protons": 52,
        "neutrons": 76
      },
      {
        "symbol": "I",
        "name": "Iodine",
        "number": 53,
        "mass": "126.90",
        "discovery": "Bernard Courtois (1811)",
        "foundInSpace": "Yes",
        "uses": "Disinfectants, thyroid function, photography",
        "price": "0.0007 USD/g",
        "story": "Iodine was discovered in 1811 by Bernard Courtois while extracting sodium salts from seaweed ash.",
        "image": "sublimation-of-iodine-solid-iodine-changes-directly-from-solid-to-gas-and-recrystallizes-on-glass-h-139822531-58b5e2d15f9b586046fb3264.webp",
        "electrons": [2, 8, 18, 18, 7],
        "protons": 53,
        "neutrons": 74
      },
      {
        "symbol": "Xe",
        "name": "Xenon",
        "number": 54,
        "mass": "131.29",
        "discovery": "William Ramsay, Morris Travers (1898)",
        "foundInSpace": "Yes",
        "uses": "Lighting, anesthesia, space propulsion",
        "price": "0.0008 USD/g",
        "story": "Xenon was discovered in 1898 by William Ramsay and Morris Travers as a component of liquefied air.",
        "image": "liquefied_xenon-58b5e2c95f9b586046fb1ab0.webp",
        "electrons": [2, 8, 18, 18, 8],
        "protons": 54,
        "neutrons": 77
      },
      {
        "symbol": "Cs",
        "name": "Cesium",
        "number": 55,
        "mass": "132.91",
        "discovery": "Robert Bunsen, Gustav Kirchhoff (1860)",
        "foundInSpace": "Yes",
        "uses": "Atomic clocks, drilling fluids, photoelectric cells",
        "price": "0.0009 USD/g",
        "story": "Cesium was discovered in 1860 by Robert Bunsen and Gustav Kirchhoff using spectroscopy.",
        "image": "download (3).jpeg",
        "electrons": [2, 8, 18, 18, 8, 1],
        "protons": 55,
        "neutrons": 78
      },
      {
        "symbol": "Ba",
        "name": "Barium",
        "number": 56,
        "mass": "137.33",
        "discovery": "Carl Wilhelm Scheele (1772), isolated by Humphry Davy (1808)",
        "foundInSpace": "Yes",
        "uses": "Medical imaging, fireworks, glass",
        "price": "0.0010 USD/g",
        "story": "Barium was identified by Carl Wilhelm Scheele in 1772 and isolated by Humphry Davy in 1808.",
        "image": "download (4).jpeg",
        "electrons": [2, 8, 18, 18, 8, 2],
        "protons": 56,
        "neutrons": 81
      },
      {
        "symbol": "La",
        "name": "Lanthanum",
        "number": 57,
        "mass": "138.91",
        "discovery": "Carl Gustaf Mosander (1839)",
        "foundInSpace": "Yes",
        "uses": "Camera lenses, hydrogen storage, catalysts",
        "price": "0.0011 USD/g",
        "story": "Lanthanum was discovered in 1839 by Carl Gustaf Mosander when he partially decomposed a sample of cerium nitrate.",
        "image": "download (5).jpeg",
        "electrons": [2, 8, 18, 18, 9, 2],
        "protons": 57,
        "neutrons": 82
      },
      {
        "symbol": "Ce",
        "name": "Cerium",
        "number": 58,
        "mass": "140.12",
        "discovery": "Martin Heinrich Klaproth, Jöns Jacob Berzelius, Wilhelm Hisinger (1803)",
        "foundInSpace": "Yes",
        "uses": "Lighter flints, polishing powders, catalysts",
        "price": "0.0013 USD/g",
        "story": "Cerium was discovered in 1803 by Klaproth, Berzelius, and Hisinger in a mineral now called cerite.",
        "image": "download (6).jpeg",
        "electrons": [2, 8, 18, 19, 9, 2],
        "protons": 58,
        "neutrons": 82
      },
      {
        "symbol": "Pr",
        "name": "Praseodymium",
        "number": 59,
        "mass": "140.91",
        "discovery": "Carl Auer von Welsbach (1885)",
        "foundInSpace": "Yes",
        "uses": "Aircraft engines, glass coloring, lasers",
        "price": "0.0012 USD/g",
        "story": "Praseodymium was discovered in 1885 by Carl Auer von Welsbach when he separated neodymium and praseodymium from didymium.",
        "image": "download (7).jpeg",
        "electrons": [2, 8, 18, 21, 8, 2],
        "protons": 59,
        "neutrons": 82
      },
      {
        "symbol": "Nd",
        "name": "Neodymium",
        "number": 60,
        "mass": "144.24",
        "discovery": "Carl Auer von Welsbach (1885)",
        "foundInSpace": "Yes",
        "uses": "Magnets, lasers, glass coloring",
        "price": "0.0014 USD/g",
        "story": "Neodymium was discovered in 1885 by Carl Auer von Welsbach when he separated neodymium and praseodymium from didymium.",
        "image": "download (8).jpeg",
        "electrons": [2, 8, 18, 22, 8, 2],
        "protons": 60,
        "neutrons": 84
      },
      // Elements 61-70 (Promethium to Ytterbium)
      {
        "symbol": "Pm",
        "name": "Promethium",
        "number": 61,
        "mass": "145",
        "discovery": "Jacob A. Marinsky, Lawrence E. Glendenin, Charles D. Coryell (1945)",
        "foundInSpace": "Yes (in stars)",
        "uses": "Nuclear batteries, luminous paint, thickness gauges",
        "price": "0.0020 USD/g",
        "story": "Promethium was first produced and characterized in 1945 at Oak Ridge National Laboratory.",
        "image": "download (9).jpeg",
        "electrons": [2, 8, 18, 23, 8, 2],
        "protons": 61,
        "neutrons": 84
      },
      {
        "symbol": "Sm",
        "name": "Samarium",
        "number": 62,
        "mass": "150.36",
        "discovery": "Lecoq de Boisbaudran (1879)",
        "foundInSpace": "Yes",
        "uses": "Magnets, lasers, cancer treatment",
        "price": "0.0015 USD/g",
        "story": "Samarium was discovered in 1879 by Lecoq de Boisbaudran from the mineral samarskite.",
        "image": "download (10).jpeg",
        "electrons": [2, 8, 18, 24, 8, 2],
        "protons": 62,
        "neutrons": 88
      },
      {
        "symbol": "Eu",
        "name": "Europium",
        "number": 63,
        "mass": "151.96",
        "discovery": "Eugène-Anatole Demarçay (1901)",
        "foundInSpace": "Yes",
        "uses": "Euro banknotes, fluorescent lamps, TV screens",
        "price": "0.0022 USD/g",
        "story": "Europium was discovered in 1901 by Eugène-Anatole Demarçay and named after the continent of Europe.",
        "image": "europium-58b5c21e5f9b586046c8f373.webp",
        "electrons": [2, 8, 18, 25, 8, 2],
        "protons": 63,
        "neutrons": 89
      },
      {
        "symbol": "Gd",
        "name": "Gadolinium",
        "number": 64,
        "mass": "157.25",
        "discovery": "Jean Charles Galissard de Marignac (1880)",
        "foundInSpace": "Yes",
        "uses": "MRI contrast agent, nuclear reactors, magnets",
        "price": "0.0025 USD/g",
        "story": "Gadolinium was discovered in 1880 by Jean Charles Galissard de Marignac and named after Johan Gadolin.",
        "image": "download (11).jpeg",
        "electrons": [2, 8, 18, 25, 9, 2],
        "protons": 64,
        "neutrons": 93
      },
      {
        "symbol": "Tb",
        "name": "Terbium",
        "number": 65,
        "mass": "158.93",
        "discovery": "Carl Gustaf Mosander (1843)",
        "foundInSpace": "Yes",
        "uses": "Color TV tubes, fluorescent lamps, sonar systems",
        "price": "0.0028 USD/g",
        "story": "Terbium was discovered in 1843 by Carl Gustaf Mosander as an impurity in yttrium oxide.",
        "image": "download (12).jpeg",
        "electrons": [2, 8, 18, 27, 8, 2],
        "protons": 65,
        "neutrons": 94
      },
      {
        "symbol": "Dy",
        "name": "Dysprosium",
        "number": 66,
        "mass": "162.50",
        "discovery": "Lecoq de Boisbaudran (1886)",
        "foundInSpace": "Yes",
        "uses": "Lasers, nuclear reactors, data storage",
        "price": "0.0030 USD/g",
        "story": "Dysprosium was discovered in 1886 by Lecoq de Boisbaudran and named from the Greek 'dysprositos' meaning 'hard to get'.",
        "image": "download (13).jpeg",
        "electrons": [2, 8, 18, 28, 8, 2],
        "protons": 66,
        "neutrons": 97
      },
      {
        "symbol": "Ho",
        "name": "Holmium",
        "number": 67,
        "mass": "164.93",
        "discovery": "Marc Delafontaine, Jacques-Louis Soret (1878)",
        "foundInSpace": "Yes",
        "uses": "Magnets, nuclear control rods, colorants",
        "price": "0.0035 USD/g",
        "story": "Holmium was discovered in 1878 by Marc Delafontaine and Jacques-Louis Soret who observed its spectrum.",
        "image": "download (14).jpeg",
        "electrons": [2, 8, 18, 29, 8, 2],
        "protons": 67,
        "neutrons": 98
      },
      {
        "symbol": "Er",
        "name": "Erbium",
        "number": 68,
        "mass": "167.26",
        "discovery": "Carl Gustaf Mosander (1843)",
        "foundInSpace": "Yes",
        "uses": "Fiber optics, lasers, glass coloring",
        "price": "0.0040 USD/g",
        "story": "Erbium was discovered in 1843 by Carl Gustaf Mosander when he separated yttria into three fractions.",
        "image": "download (15).jpeg",
        "electrons": [2, 8, 18, 30, 8, 2],
        "protons": 68,
        "neutrons": 99
      },
      {
        "symbol": "Tm",
        "name": "Thulium",
        "number": 69,
        "mass": "168.93",
        "discovery": "Per Teodor Cleve (1879)",
        "foundInSpace": "Yes",
        "uses": "Portable X-ray devices, lasers, superconductors",
        "price": "0.0045 USD/g",
        "story": "Thulium was discovered in 1879 by Per Teodor Cleve and named after Thule, an ancient name for Scandinavia.",
        "image": "download (16).jpeg",
        "electrons": [2, 8, 18, 31, 8, 2],
        "protons": 69,
        "neutrons": 100
      },
      {
        "symbol": "Yb",
        "name": "Ytterbium",
        "number": 70,
        "mass": "173.05",
        "discovery": "Jean Charles Galissard de Marignac (1878)",
        "foundInSpace": "Yes",
        "uses": "Atomic clocks, lasers, stress gauges",
        "price": "0.0050 USD/g",
        "story": "Ytterbium was discovered in 1878 by Jean Charles Galissard de Marignac in the mineral gadolinite.",
        "image": "download (17).jpeg",
        "electrons": [2, 8, 18, 32, 8, 2],
        "protons": 70,
        "neutrons": 103
      },
      // Elements 71-80 (Lutetium to Mercury)
      {
        "symbol": "Lu",
        "name": "Lutetium",
        "number": 71,
        "mass": "174.97",
        "discovery": "Georges Urbain, Carl Auer von Welsbach (1907)",
        "foundInSpace": "Yes",
        "uses": "PET scans, cancer treatment, catalysts",
        "price": "0.0060 USD/g",
        "story": "Lutetium was independently discovered in 1907 by Georges Urbain and Carl Auer von Welsbach.",
        "image": "download (18).jpeg",
        "electrons": [2, 8, 18, 32, 9, 2],
        "protons": 71,
        "neutrons": 104
      },
      {
        "symbol": "Hf",
        "name": "Hafnium",
        "number": 72,
        "mass": "178.49",
        "discovery": "Dirk Coster, George de Hevesy (1923)",
        "foundInSpace": "Yes",
        "uses": "Nuclear reactors, computer chips, plasma torches",
        "price": "0.0070 USD/g",
        "story": "Hafnium was discovered in 1923 by Dirk Coster and George de Hevesy and named after Hafnia (Latin for Copenhagen).",
        "image": "download (19).jpeg",
        "electrons": [2, 8, 18, 32, 10, 2],
        "protons": 72,
        "neutrons": 106
      },
      {
        "symbol": "Ta",
        "name": "Tantalum",
        "number": 73,
        "mass": "180.95",
        "discovery": "Anders Gustaf Ekeberg (1802)",
        "foundInSpace": "Yes",
        "uses": "Electronics, surgical implants, capacitors",
        "price": "0.0080 USD/g",
        "story": "Tantalum was discovered in 1802 by Anders Gustaf Ekeberg and named after Tantalus from Greek mythology.",
        "image": "tantalum-58b5e2a75f9b586046fab4d5.webp",
        "electrons": [2, 8, 18, 32, 11, 2],
        "protons": 73,
        "neutrons": 108
      },
      {
        "symbol": "W",
        "name": "Tungsten",
        "number": 74,
        "mass": "183.84",
        "discovery": "Juan José Elhuyar, Fausto Elhuyar (1783)",
        "foundInSpace": "Yes",
        "uses": "Light bulb filaments, armor piercing rounds, tools",
        "price": "0.0090 USD/g",
        "story": "Tungsten was discovered in 1783 by the Elhuyar brothers and has the highest melting point of all metals.",
        "image": "tungsten-or-wolfram-58b5e2a25f9b586046faa2aa.webp",
        "electrons": [2, 8, 18, 32, 12, 2],
        "protons": 74,
        "neutrons": 110
      },
      {
        "symbol": "Re",
        "name": "Rhenium",
        "number": 75,
        "mass": "186.21",
        "discovery": "Walter Noddack, Ida Tacke, Otto Berg (1925)",
        "foundInSpace": "Yes",
        "uses": "Jet engines, catalysts, thermocouples",
        "price": "0.0100 USD/g",
        "story": "Rhenium was discovered in 1925 by Walter Noddack, Ida Tacke, and Otto Berg and was the last stable element to be discovered.",
        "image": "download (20).jpeg",
        "electrons": [2, 8, 18, 32, 13, 2],
        "protons": 75,
        "neutrons": 111
      },
      {
        "symbol": "Os",
        "name": "Osmium",
        "number": 76,
        "mass": "190.23",
        "discovery": "Smithson Tennant (1803)",
        "foundInSpace": "Yes",
        "uses": "Fountain pen tips, electrical contacts, instrument pivots",
        "price": "0.0110 USD/g",
        "story": "Osmium was discovered in 1803 by Smithson Tennant and is the densest naturally occurring element.",
        "image": "osmium-crystals-58b5e2995f9b586046fa8646.webp",
        "electrons": [2, 8, 18, 32, 14, 2],
        "protons": 76,
        "neutrons": 114
      },
      {
        "symbol": "Ir",
        "name": "Iridium",
        "number": 77,
        "mass": "192.22",
        "discovery": "Smithson Tennant (1803)",
        "foundInSpace": "Yes",
        "uses": "Spark plugs, compass bearings, pen tips",
        "price": "0.0120 USD/g",
        "story": "Iridium was discovered in 1803 by Smithson Tennant and is named after Iris, the Greek goddess of the rainbow.",
        "image": "download (21).jpeg",
        "electrons": [2, 8, 18, 32, 15, 2],
        "protons": 77,
        "neutrons": 115
      },
      {
        "symbol": "Pt",
        "name": "Platinum",
        "number": 78,
        "mass": "195.08",
        "discovery": "Antonio de Ulloa (1735)",
        "foundInSpace": "Yes",
        "uses": "Jewelry, catalytic converters, laboratory equipment",
        "price": "0.0130 USD/g",
        "story": "Platinum was known to pre-Columbian Americans and was described by Antonio de Ulloa in 1735.",
        "image": "platinum-crystals-58b5e2953df78cdcd8eb3f22.webp",
        "electrons": [2, 8, 18, 32, 17, 1],
        "protons": 78,
        "neutrons": 117
      },
      {
        "symbol": "Au",
        "name": "Gold",
        "number": 79,
        "mass": "196.97",
        "discovery": "Ancient times",
        "foundInSpace": "Yes",
        "uses": "Jewelry, electronics, currency",
        "price": "0.0500 USD/g",
        "story": "Gold has been known and valued since prehistoric times and was one of the first metals used by humans.",
        "image": "gold-nugget-close-up-76128280-58b5e28e3df78cdcd8eb280a.webp",
        "electrons": [2, 8, 18, 32, 18, 1],
        "protons": 79,
        "neutrons": 118
      },
      {
        "symbol": "Hg",
        "name": "Mercury",
        "number": 80,
        "mass": "200.59",
        "discovery": "Ancient times",
        "foundInSpace": "Yes",
        "uses": "Thermometers, barometers, fluorescent lights",
        "price": "0.0001 USD/g",
        "story": "Mercury has been known since ancient times and was found in Egyptian tombs dating back to 1500 BCE.",
        "image": "droplets-of-liquid-mercury-on-round-glass-tray-close-up-72002409-58b5e2825f9b586046fa3f36.webp",
        "electrons": [2, 8, 18, 32, 18, 2],
        "protons": 80,
        "neutrons": 121
      },
      // Elements 81-90 (Thallium to Thorium)
      {
        "symbol": "Tl",
        "name": "Thallium",
        "number": 81,
        "mass": "204.38",
        "discovery": "William Crookes (1861)",
        "foundInSpace": "Yes",
        "uses": "Infrared optics, rodenticides, superconductors",
        "price": "0.0002 USD/g",
        "story": "Thallium was discovered in 1861 by William Crookes through spectroscopy and named for its green spectral line.",
        "image": "Thallium_pieces_in_ampoule-58b5e2773df78cdcd8eae8f7.webp",
        "electrons": [2, 8, 18, 32, 18, 3],
        "protons": 81,
        "neutrons": 123
      },
      {
        "symbol": "Pb",
        "name": "Lead",
        "number": 82,
        "mass": "207.2",
        "discovery": "Ancient times",
        "foundInSpace": "Yes",
        "uses": "Batteries, radiation shielding, construction",
        "price": "0.0002 USD/g",
        "story": "Lead has been known since ancient times and was used by the Romans for pipes and cooking vessels.",
        "image": "lead-metal-58b5e2723df78cdcd8ead8e8.webp",
        "electrons": [2, 8, 18, 32, 18, 4],
        "protons": 82,
        "neutrons": 125
      },
      {
        "symbol": "Bi",
        "name": "Bismuth",
        "number": 83,
        "mass": "208.98",
        "discovery": "Claude François Geoffroy (1753)",
        "foundInSpace": "Yes",
        "uses": "Pepto-Bismol, cosmetics, fire detectors",
        "price": "0.0003 USD/g",
        "story": "Bismuth was identified as distinct from lead by Claude François Geoffroy in 1753.",
        "image": "really-and-pure-chemical-elements-here-shown-bismuth-bi-173234101-58b5e26e3df78cdcd8eacbac.webp",
        "electrons": [2, 8, 18, 32, 18, 5],
        "protons": 83,
        "neutrons": 126
      },
      {
        "symbol": "Po",
        "name": "Polonium",
        "number": 84,
        "mass": "209",
        "discovery": "Pierre Curie, Marie Curie (1898)",
        "foundInSpace": "Yes (trace amounts)",
        "uses": "Static eliminators, nuclear batteries",
        "price": "0.0004 USD/g",
        "story": "Polonium was discovered in 1898 by Marie and Pierre Curie and named after Marie's homeland of Poland.",
        "image": "download (22).jpeg",
        "electrons": [2, 8, 18, 32, 18, 6],
        "protons": 84,
        "neutrons": 125
      },
      {
        "symbol": "At",
        "name": "Astatine",
        "number": 85,
        "mass": "210",
        "discovery": "Dale R. Corson, Kenneth Ross MacKenzie, Emilio Segrè (1940)",
        "foundInSpace": "Yes (trace amounts)",
        "uses": "Cancer treatment, research",
        "price": "0.0005 USD/g",
        "story": "Astatine was first produced in 1940 by bombarding bismuth with alpha particles at Berkeley.",
        "image": "download (23).jpeg",
        "electrons": [2, 8, 18, 32, 18, 7],
        "protons": 85,
        "neutrons": 125
      },
      {
        "symbol": "Rn",
        "name": "Radon",
        "number": 86,
        "mass": "222",
        "discovery": "Friedrich Ernst Dorn (1900)",
        "foundInSpace": "Yes (trace amounts)",
        "uses": "Cancer treatment, earthquake prediction",
        "price": "0.0006 USD/g",
        "story": "Radon was discovered in 1900 by Friedrich Ernst Dorn as a decay product of radium.",
        "image": "download (24).jpeg",
        "electrons": [2, 8, 18, 32, 18, 8],
        "protons": 86,
        "neutrons": 136
      },
      {
        "symbol": "Fr",
        "name": "Francium",
        "number": 87,
        "mass": "223",
        "discovery": "Marguerite Perey (1939)",
        "foundInSpace": "Yes (trace amounts)",
        "uses": "Research",
        "price": "0.0007 USD/g",
        "story": "Francium was discovered in 1939 by Marguerite Perey and named after France.",
        "image": "download (25).jpeg",
        "electrons": [2, 8, 18, 32, 18, 8, 1],
        "protons": 87,
        "neutrons": 136
      },
      {
        "symbol": "Ra",
        "name": "Radium",
        "number": 88,
        "mass": "226",
        "discovery": "Pierre Curie, Marie Curie (1898)",
        "foundInSpace": "Yes (trace amounts)",
        "uses": "Luminous paints, cancer treatment",
        "price": "0.0008 USD/g",
        "story": "Radium was discovered in 1898 by the Curies from uranium ore and named for its radioactivity.",
        "image": "download (26).jpeg",
        "electrons": [2, 8, 18, 32, 18, 8, 2],
        "protons": 88,
        "neutrons": 138
      },
      {
        "symbol": "Ac",
        "name": "Actinium",
        "number": 89,
        "mass": "227",
        "discovery": "André-Louis Debierne (1899)",
        "foundInSpace": "Yes (trace amounts)",
        "uses": "Neutron sources, cancer treatment",
        "price": "0.0009 USD/g",
        "story": "Actinium was discovered in 1899 by André-Louis Debierne in uranium residues and named for its radioactivity.",
        "image": "download (27).jpeg",
        "electrons": [2, 8, 18, 32, 18, 9, 2],
        "protons": 89,
        "neutrons": 138
      },
      {
        "symbol": "Th",
        "name": "Thorium",
        "number": 90,
        "mass": "232.04",
        "discovery": "Jöns Jacob Berzelius (1828)",
        "foundInSpace": "Yes",
        "uses": "Nuclear fuel, gas mantles, alloys",
        "price": "0.0010 USD/g",
        "story": "Thorium was discovered in 1828 by Jöns Jacob Berzelius and named after Thor, the Norse god of thunder.",
        "image": "images/Thorium.jpeg",
        "electrons": [2, 8, 18, 32, 18, 10, 2],
        "protons": 90,
        "neutrons": 142
      },
      // Elements 91-100 (Protactinium to Fermium)
      {
        "symbol": "Pa",
        "name": "Protactinium",
        "number": 91,
        "mass": "231.04",
        "discovery": "Kasimir Fajans, Oswald Helmuth Göhring (1913)",
        "foundInSpace": "Yes (trace amounts)",
        "uses": "Scientific research",
        "price": "0.0011 USD/g",
        "story": "Protactinium was first identified in 1913 and named because it decays into actinium.",
        "image": "download (28).jpeg",
        "electrons": [2, 8, 18, 32, 20, 9, 2],
        "protons": 91,
        "neutrons": 140
      },
      {
        "symbol": "U",
        "name": "Uranium",
        "number": 92,
        "mass": "238.03",
        "discovery": "Martin Heinrich Klaproth (1789)",
        "foundInSpace": "Yes",
        "uses": "Nuclear fuel, armor piercing ammunition, dating rocks",
        "price": "0.0013 USD/g",
        "story": "Uranium was discovered in 1789 by Martin Heinrich Klaproth and named after the planet Uranus.",
        "image": "gloved-hands-with-uranium-521872354-58b5e2663df78cdcd8eab82a.webp",
        "electrons": [2, 8, 18, 32, 21, 9, 2],
        "protons": 92,
        "neutrons": 146
      },
      {
        "symbol": "Np",
        "name": "Neptunium",
        "number": 93,
        "mass": "237",
        "discovery": "Edwin McMillan, Philip Abelson (1940)",
        "foundInSpace": "Yes (trace amounts)",
        "uses": "Neutron detection, research",
        "price": "0.0015 USD/g",
        "story": "Neptunium was the first transuranium element discovered in 1940 and named after Neptune.",
        "image": "download (29).jpeg",
        "electrons": [2, 8, 18, 32, 22, 9, 2],
        "protons": 93,
        "neutrons": 144
      },
      {
        "symbol": "Pu",
        "name": "Plutonium",
        "number": 94,
        "mass": "244",
        "discovery": "Glenn T. Seaborg, Arthur Wahl, Joseph W. Kennedy, Edwin McMillan (1940-1941)",
        "foundInSpace": "Yes (trace amounts)",
        "uses": "Nuclear weapons, power generation, pacemakers",
        "price": "0.0020 USD/g",
        "story": "Plutonium was first produced in 1940 and named after Pluto, continuing the planetary naming theme.",
        "image": "Plutonium-58b5e25d3df78cdcd8ea9a7c.webp",
        "electrons": [2, 8, 18, 32, 24, 8, 2],
        "protons": 94,
        "neutrons": 150
      },
      {
        "symbol": "Am",
        "name": "Americium",
        "number": 95,
        "mass": "243",
        "discovery": "Glenn T. Seaborg, Ralph A. James, Leon O. Morgan, Albert Ghiorso (1944)",
        "foundInSpace": "No",
        "uses": "Smoke detectors, neutron sources",
        "price": "0.0025 USD/g",
        "story": "Americium was discovered in 1944 and named after the Americas, analogous to europium.",
        "image": "download (30).jpeg",
        "electrons": [2, 8, 18, 32, 25, 8, 2],
        "protons": 95,
        "neutrons": 148
      },
      {
        "symbol": "Cm",
        "name": "Curium",
        "number": 96,
        "mass": "247",
        "discovery": "Glenn T. Seaborg, Ralph A. James, Albert Ghiorso (1944)",
        "foundInSpace": "No",
        "uses": "Spacecraft power sources, research",
        "price": "0.0030 USD/g",
        "story": "Curium was discovered in 1944 and named after Marie and Pierre Curie.",
        "image": "download (31).jpeg",
        "electrons": [2, 8, 18, 32, 25, 9, 2],
        "protons": 96,
        "neutrons": 151
      },
      {
        "symbol": "Bk",
        "name": "Berkelium",
        "number": 97,
        "mass": "247",
        "discovery": "Glenn T. Seaborg, Stanley G. Thompson, Albert Ghiorso (1949)",
        "foundInSpace": "No",
        "uses": "Scientific research",
        "price": "0.0035 USD/g",
        "story": "Berkelium was discovered in 1949 and named after Berkeley, California where it was first synthesized.",
        "image": "images/download (32).jpeg",
        "electrons": [2, 8, 18, 32, 27, 8, 2],
        "protons": 97,
        "neutrons": 150
      },
      {
        "symbol": "Cf",
        "name": "Californium",
        "number": 98,
        "mass": "251",
        "discovery": "Glenn T. Seaborg, Stanley G. Thompson, Kenneth Street Jr., Albert Ghiorso (1950)",
        "foundInSpace": "No",
        "uses": "Neutron sources, cancer treatment",
        "price": "0.0040 USD/g",
        "story": "Californium was discovered in 1950 and named after the state of California.",
        "image": "download (33).jpeg",
        "electrons": [2, 8, 18, 32, 28, 8, 2],
        "protons": 98,
        "neutrons": 153
      },
      {
        "symbol": "Es",
        "name": "Einsteinium",
        "number": 99,
        "mass": "252",
        "discovery": "Albert Ghiorso et al. (1952)",
        "foundInSpace": "No",
        "uses": "Scientific research",
        "price": "0.0045 USD/g",
        "story": "Einsteinium was discovered in 1952 in the debris of the first hydrogen bomb test and named after Albert Einstein.",
        "image": "download (34).jpeg",
        "electrons": [2, 8, 18, 32, 29, 8, 2],
        "protons": 99,
        "neutrons": 153
      },
      {
        "symbol": "Fm",
        "name": "Fermium",
        "number": 100,
        "mass": "257",
        "discovery": "Albert Ghiorso et al. (1952)",
        "foundInSpace": "No",
        "uses": "Scientific research",
        "price": "0.0050 USD/g",
        "story": "Fermium was discovered in 1952 in the debris of the first hydrogen bomb test and named after Enrico Fermi.",
        "image": "download (35).jpeg",
        "electrons": [2, 8, 18, 32, 30, 8, 2],
        "protons": 100,
        "neutrons": 157
      },
      // Elements 101-110 (Mendelevium to Darmstadtium)
      {
        "symbol": "Md",
        "name": "Mendelevium",
        "number": 101,
        "mass": "258",
        "discovery": "Albert Ghiorso, Glenn T. Seaborg, et al. (1955)",
        "foundInSpace": "No",
        "uses": "Scientific research",
        "price": "0.0055 USD/g",
        "story": "Mendelevium was discovered in 1955 and named after Dmitri Mendeleev, creator of the periodic table.",
        "image": "download (36).jpeg",
        "electrons": [2, 8, 18, 32, 31, 8, 2],
        "protons": 101,
        "neutrons": 157
      },
      {
        "symbol": "No",
        "name": "Nobelium",
        "number": 102,
        "mass": "259",
        "discovery": "Joint Institute for Nuclear Research (1966)",
        "foundInSpace": "No",
        "uses": "Scientific research",
        "price": "0.0060 USD/g",
        "story": "Nobelium was discovered in 1966 and named after Alfred Nobel, founder of the Nobel Prizes.",
        "image": "download (37).jpeg",
        "electrons": [2, 8, 18, 32, 32, 8, 2],
        "protons": 102,
        "neutrons": 157
      },
      {
        "symbol": "Lr",
        "name": "Lawrencium",
        "number": 103,
        "mass": "262",
        "discovery": "Albert Ghiorso, Torbjørn Sikkeland, Almon E. Larsh, Robert M. Latimer (1961)",
        "foundInSpace": "No",
        "uses": "Scientific research",
        "price": "0.0065 USD/g",
        "story": "Lawrencium was discovered in 1961 and named after Ernest O. Lawrence, inventor of the cyclotron.",
        "image": "download (38).jpeg",
        "electrons": [2, 8, 18, 32, 32, 8, 3],
        "protons": 103,
        "neutrons": 159
      },
      {
        "symbol": "Rf",
        "name": "Rutherfordium",
        "number": 104,
        "mass": "267",
        "discovery": "Joint Institute for Nuclear Research (1964)",
        "foundInSpace": "No",
        "uses": "Scientific research",
        "price": "0.0070 USD/g",
        "story": "Rutherfordium was discovered in 1964 and named after Ernest Rutherford, father of nuclear physics.",
        "image": "download (39).jpeg",
        "electrons": [2, 8, 18, 32, 32, 10, 2],
        "protons": 104,
        "neutrons": 163
      },
      {
        "symbol": "Db",
        "name": "Dubnium",
        "number": 105,
        "mass": "268",
        "discovery": "Joint Institute for Nuclear Research (1967)",
        "foundInSpace": "No",
        "uses": "Scientific research",
        "price": "0.0075 USD/g",
        "story": "Dubnium was discovered in 1967 and named after Dubna, Russia where the research institute is located.",
        "image": "download (40).jpeg",
        "electrons": [2, 8, 18, 32, 32, 11, 2],
        "protons": 105,
        "neutrons": 163
      },
      {
        "symbol": "Sg",
        "name": "Seaborgium",
        "number": 106,
        "mass": "269",
        "discovery": "Lawrence Berkeley National Laboratory (1974)",
        "foundInSpace": "No",
        "uses": "Scientific research",
        "price": "0.0080 USD/g",
        "story": "Seaborgium was discovered in 1974 and named after Glenn T. Seaborg, pioneer in transuranium elements.",
        "image": "download (41).jpeg",
        "electrons": [2, 8, 18, 32, 32, 12, 2],
        "protons": 106,
        "neutrons": 163
      },
      {
        "symbol": "Bh",
        "name": "Bohrium",
        "number": 107,
        "mass": "270",
        "discovery": "Gesellschaft für Schwerionenforschung (1981)",
        "foundInSpace": "No",
        "uses": "Scientific research",
        "price": "0.0085 USD/g",
        "story": "Bohrium was discovered in 1981 and named after Niels Bohr, pioneer in atomic structure.",
        "image": "download (42).jpeg",
        "electrons": [2, 8, 18, 32, 32, 13, 2],
        "protons": 107,
        "neutrons": 163
      },
      {
        "symbol": "Hs",
        "name": "Hassium",
        "number": 108,
        "mass": "269",
        "discovery": "Gesellschaft für Schwerionenforschung (1984)",
        "foundInSpace": "No",
        "uses": "Scientific research",
        "price": "0.0090 USD/g",
        "story": "Hassium was discovered in 1984 and named after Hesse, the German state where it was discovered.",
        "image": "download (43).jpeg",
        "electrons": [2, 8, 18, 32, 32, 14, 2],
        "protons": 108,
        "neutrons": 161
      },
      {
        "symbol": "Mt",
        "name": "Meitnerium",
        "number": 109,
        "mass": "278",
        "discovery": "Gesellschaft für Schwerionenforschung (1982)",
        "foundInSpace": "No",
        "uses": "Scientific research",
        "price": "0.0095 USD/g",
        "story": "Meitnerium was discovered in 1982 and named after Lise Meitner, who contributed to nuclear fission.",
        "image": "download (44).jpeg",
        "electrons": [2, 8, 18, 32, 32, 15, 2],
        "protons": 109,
        "neutrons": 169
      },
      {
        "symbol": "Ds",
        "name": "Darmstadtium",
        "number": 110,
        "mass": "281",
        "discovery": "Gesellschaft für Schwerionenforschung (1994)",
        "foundInSpace": "No",
        "uses": "Scientific research",
        "price": "0.0100 USD/g",
        "story": "Darmstadtium was discovered in 1994 and named after Darmstadt, the city where it was discovered.",
        "image": "download (45).jpeg",
        "electrons": [2, 8, 18, 32, 32, 17, 1],
        "protons": 110,
        "neutrons": 171
      },
      // Elements 111-118 (Roentgenium to Oganesson)
      {
        "symbol": "Rg",
        "name": "Roentgenium",
        "number": 111,
        "mass": "282",
        "discovery": "Gesellschaft für Schwerionenforschung (1994)",
        "foundInSpace": "No",
        "uses": "Scientific research",
        "price": "0.0105 USD/g",
        "story": "Roentgenium was discovered in 1994 and named after Wilhelm Röntgen, discoverer of X-rays.",
        "image": "download (46).jpeg",
        "electrons": [2, 8, 18, 32, 32, 17, 2],
        "protons": 111,
        "neutrons": 171
      },
      {
        "symbol": "Cn",
        "name": "Copernicium",
        "number": 112,
        "mass": "285",
        "discovery": "Gesellschaft für Schwerionenforschung (1996)",
        "foundInSpace": "No",
        "uses": "Scientific research",
        "price": "0.0110 USD/g",
        "story": "Copernicium was discovered in 1996 and named after Nicolaus Copernicus, who proposed the heliocentric model.",
        "image": "download (47).jpeg",
        "electrons": [2, 8, 18, 32, 32, 18, 2],
        "protons": 112,
        "neutrons": 173
      },
      {
        "symbol": "Nh",
        "name": "Nihonium",
        "number": 113,
        "mass": "286",
        "discovery": "RIKEN (2004)",
        "foundInSpace": "No",
        "uses": "Scientific research",
        "price": "0.0115 USD/g",
        "story": "Nihonium was discovered in 2004 and named after 'Nihon', which means Japan in Japanese.",
        "image": "download (48).jpeg",
        "electrons": [2, 8, 18, 32, 32, 18, 3],
        "protons": 113,
        "neutrons": 173
      },
      {
        "symbol": "Fl",
        "name": "Flerovium",
        "number": 114,
        "mass": "289",
        "discovery": "Joint Institute for Nuclear Research (1998)",
        "foundInSpace": "No",
        "uses": "Scientific research",
        "price": "0.0120 USD/g",
        "story": "Flerovium was discovered in 1998 and named after the Flerov Laboratory where it was synthesized.",
        "image": "download (49).jpeg",
        "electrons": [2, 8, 18, 32, 32, 18, 4],
        "protons": 114,
        "neutrons": 175
      },
      {
        "symbol": "Mc",
        "name": "Moscovium",
        "number": 115,
        "mass": "290",
        "discovery": "Joint Institute for Nuclear Research (2003)",
        "foundInSpace": "No",
        "uses": "Scientific research",
        "price": "0.0125 USD/g",
        "story": "Moscovium was discovered in 2003 and named after the Moscow region where the research institute is located.",
        "image": "download (50).jpeg",
        "electrons": [2, 8, 18, 32, 32, 18, 5],
        "protons": 115,
        "neutrons": 175
      },
      {
        "symbol": "Lv",
        "name": "Livermorium",
        "number": 116,
        "mass": "293",
        "discovery": "Joint Institute for Nuclear Research (2000)",
        "foundInSpace": "No",
        "uses": "Scientific research",
        "price": "0.0130 USD/g",
        "story": "Livermorium was discovered in 2000 and named after the Lawrence Livermore National Laboratory.",
        "image": "download.png",
        "electrons": [2, 8, 18, 32, 32, 18, 6],
        "protons": 116,
        "neutrons": 177
      },
      {
        "symbol": "Ts",
        "name": "Tennessine",
        "number": 117,
        "mass": "294",
        "discovery": "Joint Institute for Nuclear Research (2010)",
        "foundInSpace": "No",
        "uses": "Scientific research",
        "price": "Extremely expensive, not commercially available",
        "story": "Tennessine was discovered in 2010 and named after the state of Tennessee, location of Oak Ridge National Lab.",
        "image": "images (1).jpeg",
        "electrons": [2, 8, 18, 32, 32, 18, 7],
        "protons": 117,
        "neutrons": 177
      },
      {
        "symbol": "Og",
        "name": "Oganesson",
        "number": 118,
        "mass": "294",
        "discovery": "Joint Institute for Nuclear Research (2002)",
        "foundInSpace": "No",
        "uses": "Scientific research",
        "price": "Extremely expensive, not commercially available",
        "story": "Oganesson was discovered in 2002 and named after Yuri Oganessian, a pioneer in superheavy element research.",
        "image": "download (51).jpeg",
        "electrons": [2, 8, 18, 32, 32, 18, 8],
        "protons": 118,
        "neutrons": 176
      }
    ];

    function showSection(id) {
      document.querySelector('.container').classList.add('hidden');
      document.getElementById('quiz').classList.add('hidden');
      document.getElementById('table').classList.add('hidden');
      document.getElementById(id).classList.remove('hidden');
      if (id === 'quiz') setDifficulty(difficulty);
      if (id === 'table') renderTable();
    }

    function goHome() {
      document.querySelector('.container').classList.remove('hidden');
      document.getElementById('quiz').classList.add('hidden');
      document.getElementById('table').classList.add('hidden');
    }

    let difficulty = "easy";
    let usedQuestions = [];
    let currentSet = [], currentIndex = 0;
    let currentCategoryFilter = null;

    function setDifficulty(level) {
      difficulty = level;
      usedQuestions = [];
      currentSet = [...quizData[difficulty]];
      nextQuestion();
    }

    function showExplanation(explanation, isCorrect) {
      const notification = document.createElement('div');
      notification.className = 'explanation-notification';
      notification.innerHTML = `
        <div class="notification-content">
          <span class="notification-icon">${isCorrect ? '✓' : '✗'}</span>
          <p>${explanation}</p>
        </div>
      `;
      
      document.body.appendChild(notification);
      
      // Auto-remove after 5 seconds
      setTimeout(() => {
        notification.classList.add('fade-out');
        setTimeout(() => notification.remove(), 300);
      }, 5000);
      
      // Also allow clicking to dismiss
      notification.onclick = () => notification.remove();
    }

    function nextQuestion() {
      if (currentSet.length === 0) {
        document.getElementById("quiz-question").textContent = "Congratulations! You have answered all questions in this set.";
        document.getElementById("quiz-answers").innerHTML = "";
        return;
      }
      const randIndex = Math.floor(Math.random() * currentSet.length);
      const q = currentSet.splice(randIndex, 1)[0];
      
      // Display question with explanation button
      const questionDiv = document.getElementById('quiz-question');
      questionDiv.innerHTML = `
        ${q.question}
        <button class="explanation-button" onclick="showExplanation('${q.explanation.replace(/'/g, "\\'")}', true)">(?)</button>
      `;
      
      const aDiv = document.getElementById('quiz-answers');
      aDiv.innerHTML = '';
      q.options.forEach(opt => {
        const btn = document.createElement('button');
        btn.textContent = opt;
        btn.onclick = function () {
          const isCorrect = opt === q.answer;
          btn.classList.add(isCorrect ? 'correct' : 'wrong');
          Array.from(aDiv.children).forEach(b => {
            b.disabled = true;
            if (b.textContent === q.answer) b.classList.add('correct');
          });
          createParticles(btn, isCorrect ? '#22c55e' : '#ef4444');
          
          // Show explanation notification
          showExplanation(q.explanation, isCorrect);
        };
        aDiv.appendChild(btn);
      });
    }

    function createParticles(element, color = '#6d28d9') {
      const rect = element.getBoundingClientRect();
      const x = rect.left + rect.width / 2;
      const y = rect.top + rect.height / 2;
      
      for (let i = 0; i < 15; i++) {
        const particle = document.createElement('div');
        particle.style.position = 'fixed';
        particle.style.width = '4px';
        particle.style.height = '4px';
        particle.style.backgroundColor = color;
        particle.style.borderRadius = '50%';
        particle.style.left = `${x}px`;
        particle.style.top = `${y}px`;
        particle.style.pointerEvents = 'none';
        particle.style.zIndex = '1000';
        
        const angle = Math.random() * Math.PI * 2;
        const velocity = 1 + Math.random() * 3;
        const lifetime = 500 + Math.random() * 500;
        
        document.body.appendChild(particle);
        
        let startTime = Date.now();
        
        function animate() {
          const elapsed = Date.now() - startTime;
          const progress = elapsed / lifetime;
          
          if (progress >= 1) {
            document.body.removeChild(particle);
            return;
          }
          
          const distance = velocity * elapsed / 20;
          const currentX = x + Math.cos(angle) * distance;
          const currentY = y + Math.sin(angle) * distance;
          
          particle.style.left = `${currentX}px`;
          particle.style.top = `${currentY}px`;
          particle.style.opacity = 1 - progress;
          
          requestAnimationFrame(animate);
        }
        
        requestAnimationFrame(animate);
      }
    }

    function createAtomVisualization(element) {
      const container = document.createElement('div');
      container.className = 'atom-visualization';
      
      // Create nucleus
      const nucleus = document.createElement('div');
      nucleus.className = 'atom-nucleus';
      nucleus.textContent = `${element.protons}p ${element.neutrons}n`;
      container.appendChild(nucleus);
      
      // Create electron shells
      const maxRadius = 120;
      const shellCount = element.electrons.length;
      
      for (let i = 0; i < shellCount; i++) {
        const radius = ((i + 1) / shellCount) * maxRadius;
        const orbit = document.createElement('div');
        orbit.className = 'atom-orbit';
        orbit.style.width = `${radius * 2}px`;
        orbit.style.height = `${radius * 2}px`;
        
        // Distribute electrons evenly around the orbit
        const electronCount = element.electrons[i];
        for (let j = 0; j < electronCount; j++) {
          const angle = (j / electronCount) * Math.PI * 2;
          const electron = document.createElement('div');
          electron.className = 'atom-electron';
          
          // Position electron on orbit
          const x = radius * Math.cos(angle);
          const y = radius * Math.sin(angle);
          
          electron.style.transform = `translate(${x}px, ${y}px)`;
          electron.style.animation = `electron-orbit-${i} ${2 + i}s linear infinite`;
          
          // Add unique animation for each shell
          const style = document.createElement('style');
          style.textContent = `
            @keyframes electron-orbit-${i} {
              from { transform: translate(${x}px, ${y}px) rotate(0deg) translateX(${radius}px) rotate(0deg); }
              to { transform: translate(${x}px, ${y}px) rotate(360deg) translateX(${radius}px) rotate(-360deg); }
            }
          `;
          document.head.appendChild(style);
          
          orbit.appendChild(electron);
        }
        
        container.appendChild(orbit);
      }
      
      return container;
    }

    function showElementDetails(el) {
      const page = document.createElement('div');
      page.className = 'element-fullscreen';
      page.innerHTML = `
        <button onclick="document.body.removeChild(this.parentNode)">← Return</button>
        <div class="image-container">
          <div class="loading-spinner"></div>
          <img src="${el.image}" alt="${el.name}" 
               onload="this.parentNode.querySelector('.loading-spinner').style.display='none'; this.style.display='block';"
               onerror="this.src='https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/320px-No_image_available.svg.png'; this.parentNode.querySelector('.loading-spinner').style.display='none'; this.style.display='block';"
               style="display: none;">
        </div>
        <div class="info">
          <h2>${el.name} (${el.symbol})</h2>
          <p><strong>Atomic Number:</strong> ${el.number}</p>
          <p><strong>Atomic Mass:</strong> ${el.mass}</p>
          <p><strong>Discovered by:</strong> ${el.discovery}</p>
          <p><strong>Found in Space:</strong> ${el.foundInSpace}</p>
          <p><strong>Uses:</strong> ${el.uses}</p>
          <p><strong>Price:</strong> ${el.price}</p>
          <p><strong>Story:</strong> ${el.story}</p>
        </div>`;
      page.querySelector('.image-container').style.backgroundImage = `url('${el.image}')`;
      // Add atom visualization
      const atomViz = createAtomVisualization(el);
      page.querySelector('.info').prepend(atomViz);
      
      document.body.appendChild(page);
      
      // Add animation to the return button
      const returnBtn = page.querySelector('button');
      returnBtn.addEventListener('mouseenter', () => {
        returnBtn.innerHTML = '← Return to Table';
      });
      returnBtn.addEventListener('mouseleave', () => {
        returnBtn.innerHTML = '← Return';
      });
      
      createParticles(page.querySelector('h2'), '#a78bfa');
    }

    function renderTable(filteredElements = null) {
      const grid = document.getElementById('periodic-grid');
      grid.innerHTML = '';
      
      // Define element categories
      const categories = {
        alkali: [3, 11, 19, 37, 55, 87],
        alkaline: [4, 12, 20, 38, 56, 88],
        transition: [21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 72, 73, 74, 75, 76, 77, 78, 79, 80, 104, 105, 106, 107, 108, 109, 110, 111, 112],
        "basic-metal": [13, 31, 49, 50, 81, 82, 83, 113, 114, 115, 116],
        metalloid: [5, 14, 32, 33, 51, 52],
        nonmetal: [1, 6, 7, 8, 15, 16, 34],
        halogen: [9, 17, 35, 53, 85, 117],
        noble: [2, 10, 18, 36, 54, 86, 118],
        lanthanide: [57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71],
        actinide: [89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103]
      };
      
      // Use filtered elements if provided, otherwise use all elements
      const elementsToShow = filteredElements || elements;
      
      // Create a map of atomic number to element for quick lookup
      const elementMap = {};
      elementsToShow.forEach(el => {
        elementMap[el.number] = el;
        // Add category to element
        for (const [category, numbers] of Object.entries(categories)) {
          if (numbers.includes(el.number)) {
            el.category = category;
            break;
          }
        }
      });
      
      // Define the periodic table layout
      const layout = [
        [1, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', 2],
        [3, 4, '', '', '', '', '', '', '', '', '', '', 5, 6, 7, 8, 9, 10],
        [11, 12, '', '', '', '', '', '', '', '', '', '', 13, 14, 15, 16, 17, 18],
        [19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36],
        [37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54],
        [55, 56, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, ''],
        [87, 88, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, ''],
        ['', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', ''],
        ['', 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, '', ''],
        ['', 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, '', '']
      ];
      
      // Create rows for the periodic table
      layout.forEach((row, rowIndex) => {
        const rowDiv = document.createElement('div');
        rowDiv.className = 'periodic-row';
        if (rowIndex >= 8) {
          rowDiv.className += ' lanthanide-actinide-row';
        }
        
        row.forEach(atomicNumber => {
          if (atomicNumber === '') {
            // Empty cell
            const emptyCell = document.createElement('div');
            emptyCell.className = 'empty-cell';
            rowDiv.appendChild(emptyCell);
          } else {
            // Element cell
            const el = elementMap[atomicNumber];
            const elementDiv = document.createElement('div');
            elementDiv.className = 'element';
            elementDiv.textContent = el ? el.symbol : atomicNumber;
            if (el) {
              elementDiv.onclick = function() { 
                showElementDetails(el);
                createParticles(elementDiv);
              };
              if (el.category) {
                elementDiv.setAttribute('data-category', el.category);
              }
              
              // Apply filter if active
              if (currentCategoryFilter && el.category !== currentCategoryFilter) {
                elementDiv.classList.add('filtered-out');
              }
            } else {
              elementDiv.style.background = '#333';
              elementDiv.style.cursor = 'default';
            }
            rowDiv.appendChild(elementDiv);
          }
        });
        
        grid.appendChild(rowDiv);
      });
    }

    function filterByCategory(category) {
      currentCategoryFilter = category;
      
      // Highlight the active filter button
      document.querySelectorAll('.legend div').forEach(div => {
        div.classList.remove('active');
        if (div.getAttribute('onclick')?.includes(category)) {
          div.classList.add('active');
        }
      });
      
      // Apply filter to all elements
      document.querySelectorAll('.element').forEach(el => {
        if (el.getAttribute('data-category') === category) {
          el.classList.remove('filtered-out');
        } else {
          el.classList.add('filtered-out');
        }
      });
    }

    function clearFilters() {
      currentCategoryFilter = null;
      
      // Remove active class from all filter buttons
      document.querySelectorAll('.legend div').forEach(div => {
        div.classList.remove('active');
      });
      
      // Show all elements
      document.querySelectorAll('.element').forEach(el => {
        el.classList.remove('filtered-out');
      });
    }

    function searchElements() {
      const val = document.getElementById("search").value.toLowerCase();
      if (val === '') {
        renderTable();
        return;
      }
      const shown = elements.filter(el => 
        el.name.toLowerCase().includes(val) || 
        el.symbol.toLowerCase().includes(val) ||
        el.number.toString().includes(val)
      );
      renderTable(shown);
    }

    // Initialize the app
    document.addEventListener('DOMContentLoaded', function() {
      // Add particle effect to element clicks in the periodic table
      document.querySelectorAll('.element').forEach(el => {
        el.addEventListener('click', function() {
          const color = window.getComputedStyle(el).backgroundImage;
          createParticles(el, color);
        });
      });
    });
  </script>
</body>
</html>
