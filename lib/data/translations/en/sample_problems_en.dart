import '../../../models/problem_translation.dart';

/// English overlays for [sampleProblems]. Japanese remains the source of truth.
const sampleProblemsTranslationsEn = <String, ProblemTranslation>{
  'sample-mechanics': ProblemTranslation(
    theme: "Newton's second law (equation of motion)",
    statement:
        'As shown in the figure, an upward external force was applied so that '
        'the whole system moved together vertically upward with acceleration '
        'of magnitude 0.20 m/s². '
        'Find the magnitude of the force that block B receives from block C.\n'
        '※Take the magnitude of gravitational acceleration to be 9.8 m/s².',
    hint: 'Treat the upper two blocks as one body, and note that they accelerate upward.',
    approach:
        'Treat blocks A and B as one body and use the equation of motion.',
    firstStep: 'Taking upward as positive, 4.0 a = N − 4.0 × 9.8.',
    explanation:
        'Take upward as positive. Treating A and B as one body, the mass is '
        '1.0 + 3.0 = 4.0 kg. Let N be the magnitude of the force from C. '
        'The equation of motion is N − 4.0 × 9.8 = 4.0 × 0.20. '
        'N = 4.0 × 9.8 + 4.0 × 0.20 = 39.2 + 0.80 = 40 N.',
  ),
  'sample-electromagnetism': ProblemTranslation(
    theme: 'Electric power [W]',
    statement:
        'A 4.0 Ω resistor and an 8.0 Ω resistor are connected in series to a '
        '12 V power supply. Find the power supplied by the power supply.',
    hint: 'In series, there is a single path for the current.',
    approach: 'Find the equivalent resistance and use P = V²/R.',
    firstStep: 'The equivalent resistance is R = 4.0 + 8.0 = 12 Ω.',
    explanation:
        'In series, R = 4.0 + 8.0 = 12 Ω. '
        'The power supplied by the source is P = V²/R = 12²/12 = 144/12 = 12 W.',
  ),
  'sample-waves': ProblemTranslation(
    theme: 'Air-column vibration (closed-pipe resonance)',
    statement:
        'There is an open pipe of length 90 cm and a closed pipe of length L. '
        'The same frequency sound is sent into both, and each resonates with a '
        'standing wave that has 3 antinodes inside the pipe. Find L.\n'
        '※Count an antinode at an open end as an antinode inside the pipe, '
        'and neglect the end correction.',
    hint: 'From the number of antinodes, think how many wavelengths fit in the pipe.',
    approach:
        'An open pipe has antinodes at both ends; a closed pipe has a node at '
        'the closed end. The spacing between antinodes is λ/2, so match the '
        'wavelength and find L.',
    firstStep:
        'In the open pipe, both ends and the middle are antinodes, so there are '
        'two antinode spacings and 90 cm = λ.',
    explanation:
        'Adjacent antinodes are spaced by λ/2. '
        'An open pipe has antinodes at both ends; with 3 antinodes the middle is '
        'also an antinode. Two spacings give 90 cm = 2 × (λ/2) = λ. λ = 90 cm. '
        'A closed pipe has a node at the closed end and an antinode at the open end. '
        'Node to antinode is λ/4, then antinode spacing is λ/2. '
        'With 3 antinodes, closed end to open end is λ/4 + λ/2 + λ/2 = 5λ/4. '
        'L = 5 × 90 / 4 = 112.5 cm.',
  ),
  'sample-thermodynamics': ProblemTranslation(
    theme: 'First law of thermodynamics',
    statement:
        'Heat of 1.5×10² J was added to a gas whose internal energy was '
        '2.4×10² J, and the gas did 50 J of work on the surroundings. '
        'Find the internal energy of the gas after the work was done.',
    hint: 'The change in internal energy is the heat that entered minus the work done outward.',
    approach: 'Use the first law ΔU = Q − W, where W is the work done by the gas on the surroundings.',
    firstStep: 'ΔU = 1.5×10² − 50.',
    explanation:
        'The first law is ΔU = Q − W, with W the work done by the gas. '
        'ΔU = 1.5×10² − 50 = 100 J. '
        'After the work, the internal energy is 2.4×10² + ΔU = 240 + 100 = 340 J.',
  ),
  'sample-atom': ProblemTranslation(
    theme: 'Radioactive decay and half-life',
    statement:
        'A radioactive nucleus has a half-life of 8.0 days. If there were '
        '3.2×10⁶ nuclei initially, how many remain after 24 days?',
    hint: 'First count how many half-lives have passed.',
    approach: 'In radioactive decay, the number halves every half-life.',
    firstStep: 'The elapsed time is 3 half-lives: 24 / 8.0 = 3.',
    explanation:
        'The remaining number is N = N₀ × (1/2)^(t/T). '
        't/T = 24 / 8.0 = 3, so N = 3.2×10⁶ × (1/2)³ = 3.2×10⁶ / 8 = 4.0×10⁵.',
  ),
  'sample-fusion': ProblemTranslation(
    theme: 'Heat',
    statement:
        'A 0.50 kg object was dropped from a height of 2.0 m into water in an '
        'insulated container. All of the object’s mechanical energy became heat '
        'in the water and raised its temperature. Find the heat received by the water.\n'
        '※Take g = 9.8 m/s², and neglect air resistance and heat flow to the container.',
    hint:
        'The energy lost while falling becomes the heat received by the water.',
    approach: 'Treat the lost gravitational potential energy as heat in the thermodynamic sense.',
    firstStep: 'The mechanical energy lost is mgh.',
    explanation:
        'With no air resistance and no heat to the container, the mechanical '
        'energy lost by the object equals the heat Q received by the water. '
        'That loss is potential energy, so Q = mgh = 0.50 × 9.8 × 2.0 = 9.8 J.',
  ),
  'sample-sliding': ProblemTranslation(
    theme: 'Work and energy',
    statement:
        'On a horizontal surface, an object given a speed of 5.0 m/s slid a '
        'distance L and stopped. On the same surface, when given speed v₀ it '
        'slid a distance 4L and stopped. Find v₀.',
    hint: 'When it stops, kinetic energy has been lost to the work done by kinetic friction.',
    approach: 'Apply work–energy (1/2) m v² = f x to both slides.',
    firstStep: '(1/2) m × 5.0² = f L and (1/2) m v₀² = f × 4L.',
    explanation:
        'The kinetic friction magnitude f is the same. When stopped, KE is 0, so '
        '(1/2) m v² = f x. '
        '(1/2) m × 5.0² = f L and (1/2) m v₀² = f × 4L. '
        'Dividing gives v₀² / 5.0² = 4L / L = 4. '
        'v₀ = 5.0 × 2 = 10 m/s.',
  ),
  'sample-electrons': ProblemTranslation(
    theme: 'Definition of electric current [A]',
    statement:
        'A current of 1.6×10³ mA flows in a resistor. '
        'Find how many free electrons pass a cross section of the resistor in 5 s.\n'
        '※Take the elementary charge to be 1.6×10⁻¹⁹ C.',
    hint: 'Current is the charge that passes the cross section per second.',
    approach: 'Find the charge in 5 s, then divide by the elementary charge.',
    firstStep: '1.6×10³ mA = 1.6 A, so Q = 1.6 × 5.',
    explanation:
        'By definition I = Q/t, so Q = It. '
        '1.6×10³ mA = 1.6 A. Q = 1.6 × 5 = 8.0 C. '
        'With elementary charge e, n = Q/e = 8.0 / (1.6×10⁻¹⁹) = 5.0×10¹⁹.',
  ),
  'sample-free-end': ProblemTranslation(
    theme: 'Node of free-end reflection',
    statement:
        'A sine wave of amplitude 3.0 cm and frequency 5.0 Hz travels in the '
        'positive x direction at 0.60 m/s and is free-end reflected at a wall '
        'at x = 20 cm. For the resulting wave on the x-axis, find the x '
        'coordinate of the point whose displacement does not change with time '
        'that is closest to the wall.',
    hint:
        'The wall is a free end, so it is an antinode. A point with no time-varying '
        'displacement lies a quarter wavelength from an antinode.',
    approach:
        'Find the wavelength, treat the free-end wall as an antinode, and find '
        'the nearest node.',
    firstStep: 'λ = 0.60 / 5.0 = 0.12 m = 12 cm.',
    explanation:
        'λ = v/f = 0.60 / 5.0 = 0.12 m = 12 cm. '
        'Free-end reflection means the wall at x = 20 cm is an antinode. '
        'In a standing wave, antinode to neighboring node is λ/4, so the nearest '
        'node is x = 20 − 12/4 = 20 − 3.0 = 17 cm. Amplitude is not needed for the node.',
  ),
  'sample-fixed-end': ProblemTranslation(
    theme: 'Node of fixed-end reflection',
    statement:
        'A sine wave of amplitude 3.0 cm and frequency 5.0 Hz travels in the '
        'positive x direction at 0.60 m/s and is fixed-end reflected at a wall '
        'at x = 20 cm. For the resulting wave on the x-axis, find the x '
        'coordinate of the point whose displacement does not change with time '
        'that is closest to the wall.',
    hint:
        'The wall is a fixed end, so it is a node. Among points with no time-varying '
        'displacement, the closest to the wall is the wall itself.',
    approach:
        'Find the wavelength and treat the fixed-end wall as a node. The nearest '
        'stationary point is the wall itself.',
    firstStep: 'λ = 0.60 / 5.0 = 0.12 m = 12 cm.',
    explanation:
        'λ = v/f = 0.60 / 5.0 = 0.12 m = 12 cm. '
        'Fixed-end reflection means the medium cannot move at the wall, so '
        'x = 20 cm is a node. Points with no time-varying displacement are nodes, '
        'so the closest is this point: x = 20 cm. '
        'The next node is λ/2 = 6.0 cm before the next antinode, at x = 14 cm.',
  ),
  'sample-spectrum': ProblemTranslation(
    theme: 'Order of electromagnetic wavelengths',
    statement:
        'Arrange infrared, ultraviolet, radio waves, visible light, and X-rays '
        'from left to right in order of increasing wavelength (shortest first).',
    answerDisplay: 'X-rays, ultraviolet, visible light, infrared, radio waves',
    symbolChoices: [
      'infrared',
      'ultraviolet',
      'radio waves',
      'visible light',
      'X-rays',
    ],
    symbolOrder: 'X-rays, ultraviolet, visible light, infrared, radio waves',
    hint: 'Put visible light in the middle. X-rays are shorter; radio waves are longest.',
    approach:
        'Order electromagnetic waves from shortest wavelength to longest.',
    firstStep: 'The shortest wavelength is X-rays.',
    explanation:
        'Shortest to longest: X-rays, ultraviolet, visible light, infrared, radio waves.',
  ),
  'sample-spring-pulleys': ProblemTranslation(
    theme: "Hooke's law",
    statement:
        'As shown, a light spring of spring constant 196 N/m lies horizontally. '
        'Through pulleys, a 4.0 kg mass hangs from each end, and the system is at rest. '
        'Find the extension of the spring from its natural length.\n'
        '※Take g = 9.8 m/s² and assume the pulleys are frictionless.',
    hint: 'For a hanging mass at rest, tension balances weight.',
    approach: 'Find the tension; it equals the force stretching the spring.',
    firstStep: 'The tension is T = 4.0 × 9.8.',
    explanation:
        'Each mass is at rest. Taking upward positive, T − mg = 0. '
        'T = 4.0 × 9.8 = 39.2 N. '
        'This tension stretches the spring, so kx = T. '
        '196 x = 39.2. x = 0.20 m = 20 cm.',
  ),
  'sample-air-resistance': ProblemTranslation(
    theme: 'Work and energy',
    statement:
        'As shown, a 2.0 kg mass attached to a massless spring is pressed toward '
        'the floor so the spring is compressed 0.20 m from its natural length, '
        'then released. It rises against air resistance and reaches 0.50 m above '
        'the release point before falling back. Find the work done on the mass '
        'by air resistance.\n'
        '※Take g = 9.8 m/s² and spring constant 980 N/m.',
    hint:
        'At the highest point the speed is 0. The lost mechanical energy equals '
        'the work by air resistance.',
    approach:
        'Take the release height as the zero of potential energy and compare '
        'elastic energy with potential energy at the top.',
    firstStep: 'The initial elastic energy is (1/2) × 980 × 0.20².',
    explanation:
        'Take potential energy zero at the release height. Speed is 0 just after '
        'release, so mechanical energy is only elastic: '
        'E_i = (1/2) k x² = (1/2)×980×0.20² = 19.6 J. '
        'At the top, speed is 0 and height is 0.50 m, so E_f = mgh = 2.0×9.8×0.50 = 9.8 J. '
        'With work W by air resistance, E_i + W = E_f. '
        'W = 9.8 − 19.6 = −9.8 J.',
  ),
  'sample-ac-power': ProblemTranslation(
    theme: 'Definition of rms current and voltage',
    statement:
        'As shown, a 10 kΩ resistor is connected to an AC source with rms voltage '
        '240 V. Find the power consumed in the resistor.',
    hint:
        'Voltage is sinusoidal; rms is the amplitude divided by √2. Consumed power '
        'is the average of instantaneous power over one period.',
    approach: 'Take amplitude V₀ = 240√2 and average instantaneous power vi over one period.',
    firstStep: 'Voltage is v = 240√2 sin ωt and current is i = v/R.',
    explanation:
        'Rms 240 V means amplitude V₀ = 240√2 V. '
        'Across a resistor, current is in phase: v = V₀ sin ωt, i = (V₀/R) sin ωt. '
        'Instantaneous power p = vi = (V₀²/R) sin² ωt. '
        'Average over period T: P = (1/T) ∫₀ᵀ p dt = (V₀²/R) × (1/T) ∫₀ᵀ sin² ωt dt. '
        'sin² ωt = (1 − cos 2ωt)/2, so the cos term averages to 0 and '
        '∫₀ᵀ sin² ωt dt = T/2. Thus P = V₀²/(2R). With V₀² = (240√2)² = 2×240², '
        'P = 240²/R. With 10 kΩ = 1.0×10⁴ Ω, '
        'P = 240²/(1.0×10⁴) = 57600/10000 = 5.76 W.',
  ),
  'sample-incline': ProblemTranslation(
    theme: 'Force balance',
    statement:
        'As shown, on a rough incline at 30° to the horizontal, a 10 kg mass is '
        'pulled up at constant speed by a light inextensible string. '
        'Find the magnitude of the string tension.\n'
        '※Take g = 9.8 m/s², kinetic friction coefficient 0.50, and √3 = 1.73.',
    hint:
        'Constant speed means acceleration is 0. While pulling up, kinetic friction '
        'acts down the incline.',
    approach: 'Write force balance perpendicular to the incline and along the incline.',
    firstStep:
        'Perpendicular to the incline, with normal force N, '
        'N − 10 × 9.8 × cos 30° = 0.',
    explanation:
        'Take up the incline as positive. Constant speed means a = 0. '
        'Perpendicular balance: N = mg cos 30°. '
        'Kinetic friction magnitude f = μN, directed down the incline. '
        'Along the incline: T − mg sin 30° − f = 0. '
        'sin 30° = 1/2, cos 30° = √3/2 = 1.73/2 = 0.865. '
        'mg sin 30° = 10 × 9.8 × 1/2 = 49 N. '
        'N = 10 × 9.8 × 0.865 = 84.77 N. f = 0.50 × 84.77 = 42.385 N. '
        'T = 49 + 42.385 = 91.385 N.',
  ),
  'a3ed863f-73f0-4ba2-977a-268f464df3ad': ProblemTranslation(
    theme: "Definition of electrical resistance (Ohm's law)",
    statement:
        'As shown, an 18 Ω resistor is connected to a 9.0 V battery. '
        'Find the magnitude of the current in the resistor.',
    hint:
        'There is one resistor, and both the voltage across it and its resistance '
        'are given. The current is fixed by those two.',
    approach: "Use Ohm's law, V = RI.",
    firstStep: '9.0 = 18 I.',
    explanation:
        "Ohm's law is V = RI. "
        'There is one resistor, so the battery voltage is across it: 9.0 = 18 I. '
        'I = 9.0 / 18 = 0.50 A.',
  ),
  'b6cb0c9c-869b-44b0-a121-e28b7bca1597': ProblemTranslation(
    theme: 'Combined resistance',
    statement:
        'As shown, a 2.0 Ω resistor and a 6.0 Ω resistor are connected in series '
        'to an 8.0 V battery. Find the magnitude of the current in the circuit.',
    hint:
        'The two resistors lie on a single path. The current is fixed by the '
        'combined resistance and the battery voltage.',
    approach:
        "Find the series equivalent resistance and use Ohm's law, V = RI.",
    firstStep: 'The equivalent resistance is R = 2.0 + 6.0 = 8.0 Ω.',
    explanation:
        'In series, the equivalent resistance is the sum of the resistances. '
        'R = 2.0 + 6.0 = 8.0 Ω. '
        "Ohm's law is V = RI, so 8.0 = 8.0 I. "
        'I = 8.0 / 8.0 = 1.0 A.',
  ),
  '4f9096d1-35ee-49ee-b4c9-48041c56cdee': ProblemTranslation(
    theme: 'Parallel equivalent resistance',
    statement:
        'As shown, a 3.0 Ω resistor and a 6.0 Ω resistor are connected in '
        'parallel to a 6.0 V battery. Find the magnitude of the current in '
        'the wire before the current splits.',
    hint:
        'Both resistors receive the full battery voltage. The current before '
        'the split is fixed by the resistance of the two paths taken together.',
    approach:
        "Find the parallel equivalent resistance and use Ohm's law, V = RI.",
    firstStep: '1/R = 1/3.0 + 1/6.0.',
    explanation:
        'For resistors in parallel, 1/R = 1/R1 + 1/R2. '
        '1/R = 1/3.0 + 1/6.0 = 2/6.0 + 1/6.0 = 1/2.0, so R = 2.0 Ω. '
        'Before the split, the battery voltage is across this equivalent '
        "resistance. Ohm's law is V = RI, so 6.0 = 2.0 I. "
        'I = 6.0 / 2.0 = 3.0 A.',
  ),
  '5adf49b5-0a92-439b-9f65-88ad58a94bc3': ProblemTranslation(
    theme: 'Voltage drop in a bridge-shaped circuit',
    statement:
        'As shown, find the magnitude of the voltage drop across the '
        'upper-left resistor.',
    hint:
        'The upper-left and lower-left resistors are one path, and its ends '
        'are the battery. The current is fixed by that path; the voltage drop '
        'asked for is only the upper-left resistor.',
    approach: "Use Ohm's law, V = RI.",
    firstStep: 'On the left path, 6.0 = (4.0 + 8.0) I.',
    explanation:
        "Ohm's law is V = RI. "
        'The upper-left 4.0 Ω and the lower-left 8.0 Ω are in series, and the '
        'voltage across that path is the battery\'s 6.0 V, so 6.0 = (4.0 + 8.0) I. '
        'I = 6.0 / 12 = 0.50 A. The upper-left voltage drop is V = 4.0 × 0.50 = 2.0 V.',
  ),
  '059e9128-3c09-4e75-9a6b-8c401a807e7c': ProblemTranslation(
    theme: "Isothermal change (Boyle's law)",
    statement:
        'As shown, while keeping the temperature at 300 K, the volume of an '
        'ideal gas at 2.0×10⁵ Pa and 4.0×10⁻³ m³ is changed to 8.0×10⁻³ m³. '
        'Find the pressure then.',
    hint: 'The temperature has not changed. The product of pressure and volume is kept.',
    approach: "Use Boyle's law, PV = constant.",
    firstStep: '2.0×10⁵ × 4.0×10⁻³ = P × 8.0×10⁻³.',
    explanation:
        "For an isothermal change, Boyle's law is PV = constant. "
        '2.0×10⁵ × 4.0×10⁻³ = P × 8.0×10⁻³. '
        'P = 2.0×10⁵ × 4.0×10⁻³ / 8.0×10⁻³ = 1.0×10⁵ Pa.',
  ),
  '62dce096-726f-4a28-8139-de3eff094793': ProblemTranslation(
    theme: "Isobaric change (Charles's law)",
    statement:
        'As shown, while keeping the pressure at 1.0×10⁵ Pa, an ideal gas at '
        '300 K and volume 2.0×10⁻³ m³ is brought to 450 K. Find the volume then.',
    hint: 'The pressure has not changed. The ratio of volume to absolute temperature is kept.',
    approach: "Use Charles's law, V/T = constant.",
    firstStep: '2.0×10⁻³ / 300 = V / 450.',
    explanation:
        "For an isobaric change, Charles's law is V/T = constant. "
        '2.0×10⁻³ / 300 = V / 450. '
        'V = 2.0×10⁻³ × 450 / 300 = 3.0×10⁻³ m³.',
  ),
  'bf43572d-42ac-4b81-9dce-85c4a71ee6d7': ProblemTranslation(
    theme: 'Isochoric change',
    statement:
        'As shown, while keeping the volume at 2.0×10⁻³ m³, an ideal gas at '
        '300 K and 1.5×10⁵ Pa is brought to 600 K. Find the pressure then.',
    hint: 'The volume has not changed. The ratio of pressure to absolute temperature is kept.',
    approach: "Use Gay-Lussac's law, P/T = constant.",
    firstStep: '1.5×10⁵ / 300 = P / 600.',
    explanation:
        "For an isochoric change, Gay-Lussac's law is P/T = constant. "
        '1.5×10⁵ / 300 = P / 600. '
        'P = 1.5×10⁵ × 600 / 300 = 3.0×10⁵ Pa.',
  ),
  '2eef6ac4-67da-439f-b4fa-d6436a743eb8': ProblemTranslation(
    theme: "Adiabatic change (Poisson's equation)",
    statement:
        'As shown, with no heat exchanged with the surroundings, a monatomic '
        'ideal gas at 1.0×10⁵ Pa and volume 8.0×10⁻³ m³ is compressed to '
        '1.0×10⁻³ m³. Find the pressure then.\n'
        '※Take γ = 5/3.',
    hint:
        'There is no heat exchange with the surroundings. Pressure and volume '
        'are related differently from the product used when temperature is constant.',
    approach: "Use Poisson's equation, P V^γ = constant.",
    firstStep: '1.0×10⁵ × (8.0×10⁻³)^{5/3} = P × (1.0×10⁻³)^{5/3}.',
    explanation:
        "For an adiabatic change, Poisson's equation is P V^γ = constant, with γ = 5/3. "
        '1.0×10⁵ × (8.0×10⁻³)^{5/3} = P × (1.0×10⁻³)^{5/3}. '
        'The volume ratio is 8.0×10⁻³ / 1.0×10⁻³ = 8.0. '
        '8.0^{5/3} = (8.0^{1/3})^5 = 2.0^5 = 32. '
        'P = 1.0×10⁵ × 32 = 3.2×10⁶ Pa.',
  ),
  '6dbf478a-bb30-40a4-bacb-c7c1ddd5b550': ProblemTranslation(
    theme: 'Internal energy of a gas',
    statement:
        'As shown, two vessels separated by a stopcock contain a monatomic '
        'ideal gas. After the stopcock is opened and enough time has passed, '
        'find the pressure of the gas.\n'
        '※There is no heat exchange with the outside of the vessels, and the '
        'volumes of the vessels do not change.',
    hint:
        'While the stopcock is open, the gas is not in equilibrium. There is '
        'no work done on the outside and no heat exchange.',
    approach:
        'Use conservation of the total internal energy of a monatomic ideal '
        'gas, U = (3/2) pV.',
    firstStep:
        '(3/2)×2.0×10⁵×3.0×10⁻³ + (3/2)×1.0×10⁵×2.0×10⁻³ = (3/2) P × 5.0×10⁻³.',
    explanation:
        'For a monatomic ideal gas, U = (3/2) nRT = (3/2) pV. '
        'While the stopcock is open there is no heat exchange with the outside, '
        'and the vessel volumes do not change, so there is no work on the outside. '
        'The sum of internal energies is therefore unchanged. '
        '(3/2)×2.0×10⁵×3.0×10⁻³ + (3/2)×1.0×10⁵×2.0×10⁻³ = (3/2) P × 5.0×10⁻³. '
        '2.0×10⁵×3.0×10⁻³ + 1.0×10⁵×2.0×10⁻³ = P × 5.0×10⁻³. '
        '6.0×10² + 2.0×10² = 5.0×10⁻³ P. '
        'P = 8.0×10² / 5.0×10⁻³ = 1.6×10⁵ Pa.',
  ),
  'c6d333a8-fdff-45e6-ae3d-d576394a8f58': ProblemTranslation(
    theme: 'Molar heat capacity of a diatomic ideal gas',
    statement:
        'As shown, two vessels separated by a stopcock contain a diatomic '
        'ideal gas. After the stopcock is opened and enough time has passed, '
        'find the temperature of the gas.\n'
        '※There is no heat exchange with the outside of the vessels, and the '
        'volumes of the vessels do not change.',
    hint:
        'While the stopcock is open, the gas is not in equilibrium. There is '
        'no work done on the outside and no heat exchange, and the amount of '
        'substance is conserved.',
    approach:
        'Use conservation of the total internal energy of a diatomic ideal '
        'gas, U = (5/2) nRT.',
    firstStep: '(5/2)×2.0×R×300 + (5/2)×1.0×R×900 = (5/2)×(2.0+1.0)×R×T.',
    explanation:
        'For a diatomic ideal gas the molar heat capacity at constant volume '
        'is C_V = (5/2) R, so U = n C_V T = (5/2) nRT. '
        'While the stopcock is open there is no heat exchange with the outside, '
        'and the vessel volumes do not change, so there is no work on the outside. '
        'The sum of internal energies is therefore unchanged, and so is the '
        'total amount of substance. '
        '(5/2)×2.0×R×300 + (5/2)×1.0×R×900 = (5/2)×(2.0+1.0)×R×T. '
        '2.0×300 + 1.0×900 = 3.0 T. '
        '600 + 900 = 3.0 T. '
        'T = 1500 / 3.0 = 500 K.',
  ),
  '680f161b-8039-4d8b-97ac-54d641bf875e': ProblemTranslation(
    theme: 'Period of vertical-spring SHM',
    statement:
        'As shown, a mass is hung from a spring attached to the ceiling and '
        'released gently. The mass then oscillates vertically. Find the period '
        'of this oscillation.\n'
        '※Take π = 3.14.',
    hint:
        'Both gravity and the spring force act on the mass. Look at the '
        'displacement from the equilibrium position.',
    approach:
        'Write the equation of motion about equilibrium and use T = 2π √(m/k).',
    firstStep: 'T = 2π √(1.0 / 4.0).',
    explanation:
        'Take downward as positive. Let x be the extension from the natural '
        'length. The equation of motion is mẍ = mg − kx. '
        'At equilibrium, 0 = mg − kδ, so δ = mg/k. '
        'With y = x − δ, ẍ = ÿ and mÿ = −ky, so ÿ = −(k/m) y. '
        'The angular frequency is ω = √(k/m), so T = 2π/ω = 2π √(m/k). '
        'T = 2 × 3.14 × √(1.0/4.0) = 6.28 × 0.50 = 3.14 s.',
  ),
  '63f5a83f-3152-4583-8c46-67bc2e33d8bc': ProblemTranslation(
    theme: 'Period of a simple pendulum',
    statement:
        'As shown, a small mass is attached to a string and given a small '
        'swing in a vertical plane. Find the period of this oscillation.\n'
        '※Take g = 9.8 m/s² and π = 3.14.',
    hint:
        'The swing is small. Look at the displacement along the arc, not along '
        'the string.',
    approach:
        'Approximate the equation of motion for a small angle and use '
        'T = 2π √(L/g).',
    firstStep: 'T = 2π √(2.45 / 9.8).',
    explanation:
        'Let θ be the angle in the vertical plane. The tangential equation of '
        'motion is m L θ̈ = −mg sin θ. '
        'For a small swing, sin θ ≈ θ, so θ̈ = −(g/L) θ. '
        'The angular frequency is ω = √(g/L), so T = 2π/ω = 2π √(L/g). '
        'T = 2 × 3.14 × √(2.45/9.8) = 6.28 × √0.25 = 6.28 × 0.50 = 3.14 s.',
  ),
  '11cf8d71-4c2b-45ed-bb3e-3718131609c2': ProblemTranslation(
    theme: "Kepler's third law",
    statement:
        'As shown, two bodies orbit the Sun. Find the orbital period of the '
        'body whose distance from the Sun is 4.0×10⁸ km.',
    hint:
        'The distances of the two orbits from the Sun are given, and so is '
        'one of the periods.',
    approach: "Use Kepler's third law, T² ∝ a³.",
    firstStep: '(T / 1)² = (4.0×10⁸ / 1.0×10⁸)³.',
    explanation:
        "Kepler's third law is T² / a³ = constant. "
        '(T / 1)² = (4.0×10⁸ / 1.0×10⁸)³ = 4.0³ = 64. '
        'T = 8 years.',
  ),
  '94b33f1d-6d59-425c-9481-9b73a8686890': ProblemTranslation(
    theme: 'Beats',
    statement:
        'As shown, the tuning forks on the left and right were sounded '
        'together, and between them the loudness repeatedly grew stronger '
        'and weaker. Find the period of this repetition.',
    hint:
        'The two tuning forks have slightly different frequencies. The '
        'interval at which the loudness repeats is fixed by that difference.',
    approach: 'Use the beat period T = 1/|f1 − f2|.',
    firstStep: 'T = 1/|442 − 440|.',
    explanation:
        'The beat frequency is |f1 − f2|. The period is its reciprocal, so '
        'T = 1/|f1 − f2|. T = 1/|442 − 440| = 1/2 = 0.5 s.',
  ),
};
