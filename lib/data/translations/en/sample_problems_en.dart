import '../../../models/problem_translation.dart';

/// English overlays for [sampleProblems]. Japanese remains the source of truth.
const sampleProblemsTranslationsEn = <String, ProblemTranslation>{
  'sample-mechanics': ProblemTranslation(
    theme: "Newton's second law (equation of motion)",
    title: 'Force that block B receives from block C',
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
    title: 'Power supplied by a source in a series circuit',
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
    title: 'Length of a closed pipe with three antinodes',
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
    title: 'Internal energy after heat and work',
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
    title: 'Nuclei remaining after half-lives',
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
    title: 'Heat given to water by a falling object',
    statement:
        'As shown, a 0.50 kg object was dropped from a height of 2.0 m into water in an '
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
    title: 'Initial speed to slide four times as far',
    statement:
        'On a horizontal surface, an object given an initial speed of 5.0 m/s '
        'slid a distance L and stopped. On the same surface, what initial speed '
        'must it be given to slide four times as far?',
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
    title: 'Number of electrons passing through a resistor',
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
    title: 'Node nearest the wall in free-end reflection',
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
    title: 'Node nearest the wall in fixed-end reflection',
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
    title: 'Electromagnetic waves from the shortest wavelength',
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
    explanation: 'Shortest to longest: X-rays, ultraviolet, visible light, infrared, radio waves.',
  ),
  'sample-spring-pulleys': ProblemTranslation(
    theme: "Hooke's law",
    title: 'Extension of a spring with a mass at each end',
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
    title: 'Work done by air resistance on a rising mass',
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
    title: 'Power consumed by a resistor on an AC source',
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
    title: 'Tension pulling a block up an incline at constant speed',
    statement:
        'As shown, on a rough incline at 30° to the horizontal, a 10 kg mass is '
        'pulled up at constant speed by a light inextensible string. '
        'Find the magnitude of the string tension.\n'
        '※Take g = 9.8 m/s², kinetic friction coefficient 1/√3, and √3 = 1.73.',
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
        'Therefore T = mg sin 30° + μ mg cos 30° = mg (sin 30° + μ cos 30°). '
        'sin 30° = 1/2, cos 30° = √3/2, and μ = 1/√3, so '
        'μ cos 30° = (1/√3) × (√3/2) = 1/2. '
        'T = mg (1/2 + 1/2) = mg = 10 × 9.8 = 98 N.',
  ),
  'a3ed863f-73f0-4ba2-977a-268f464df3ad': ProblemTranslation(
    theme: "Definition of electrical resistance (Ohm's law)",
    title: 'Current in a resistor connected to a battery',
    statement:
        'As shown, a 100 Ω resistor is connected to a 9.0 V battery. '
        'Find the magnitude of the current in the resistor.',
    hint:
        'There is one resistor, and both the voltage across it and its resistance '
        'are given. The current is fixed by those two.',
    approach: "Use Ohm's law, V = RI.",
    firstStep: '9.0 = 100 I.',
    explanation:
        "Ohm's law is V = RI. "
        'There is one resistor, so the battery voltage is across it: 9.0 = 100 I. '
        'I = 9.0 / 100 = 0.09 A.',
  ),
  'b6cb0c9c-869b-44b0-a121-e28b7bca1597': ProblemTranslation(
    theme: 'Combined resistance',
    title: 'Current through two resistors in series',
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
    title: 'Current through two resistors in parallel',
    statement:
        'As shown, a 100 Ω resistor and a 150 Ω resistor are connected in '
        'parallel to a 3.0 V battery. Find the magnitude of the current at point P.',
    hint:
        'Point P is on the wire before the current divides between the two '
        'resistors. Both resistors receive the full battery voltage.',
    approach:
        "Find the parallel equivalent resistance and use Ohm's law, V = RI.",
    firstStep: '1/R = 1/100 + 1/150.',
    explanation:
        'For resistors in parallel, 1/R = 1/R1 + 1/R2. '
        '1/R = 1/100 + 1/150 = 3/300 + 2/300 = 5/300 = 1/60, so R = 60 Ω. '
        'At point P, the battery voltage is across this equivalent '
        "resistance. Ohm's law is V = RI, so 3.0 = 60 I. "
        'I = 3.0 / 60 = 0.05 A.',
  ),
  '5adf49b5-0a92-439b-9f65-88ad58a94bc3': ProblemTranslation(
    theme: 'Voltage drop in a bridge-shaped circuit',
    title: 'Voltage drop between points A and B',
    statement: 'As shown, find the magnitude of the voltage drop between points A and B.',
    hint:
        'Points A and B are the two ends of the upper-left resistor. The '
        'upper-left and lower-left resistors are one path, and its ends are '
        'the battery.',
    approach: "Use Ohm's law, V = RI.",
    firstStep: 'On the left path, 6.0 = (4.0 + 8.0) I.',
    explanation:
        "Ohm's law is V = RI. "
        'The upper-left 4.0 Ω and the lower-left 8.0 Ω are in series, and the '
        'voltage across that path is the battery\'s 6.0 V, so 6.0 = (4.0 + 8.0) I. '
        'I = 6.0 / 12 = 0.50 A. The voltage drop between A and B is '
        'V = 4.0 × 0.50 = 2.0 V.',
  ),
  '059e9128-3c09-4e75-9a6b-8c401a807e7c': ProblemTranslation(
    theme: "Isothermal change (Boyle's law)",
    title: 'Pressure after changing the volume at constant temperature',
    statement:
        'As shown, while keeping the temperature at 293 K, the volume of an '
        'ideal gas at 1013 hPa and 2.0×10⁻³ m³ is changed to 4.0×10⁻³ m³. '
        'Find the pressure then.',
    hint: 'The temperature has not changed. The product of pressure and volume is kept.',
    approach: "Use Boyle's law, PV = constant.",
    firstStep: '1013 × 2.0×10⁻³ = P × 4.0×10⁻³.',
    explanation:
        "For an isothermal change, Boyle's law is PV = constant. "
        '1013 × 2.0×10⁻³ = P × 4.0×10⁻³. '
        'P = 1013 × 2.0×10⁻³ / 4.0×10⁻³ = 506.5 hPa.',
  ),
  '62dce096-726f-4a28-8139-de3eff094793': ProblemTranslation(
    theme: "Isobaric change (Charles's law)",
    title: 'Volume after changing the temperature at constant pressure',
    statement:
        'As shown, while keeping the pressure at 1013 hPa, an ideal gas at '
        '300 K and volume 2.0×10⁻³ m³ is brought to 360 K. Find the volume then.',
    hint: 'The pressure has not changed. The ratio of volume to absolute temperature is kept.',
    approach: "Use Charles's law, V/T = constant.",
    firstStep: '2.0×10⁻³ / 300 = V / 360.',
    explanation:
        "For an isobaric change, Charles's law is V/T = constant. "
        '2.0×10⁻³ / 300 = V / 360. '
        'V = 2.0×10⁻³ × 360 / 300 = 2.4×10⁻³ m³.',
  ),
  'bf43572d-42ac-4b81-9dce-85c4a71ee6d7': ProblemTranslation(
    theme: 'Isochoric change',
    title: 'Pressure after changing the temperature at constant volume',
    statement:
        'As shown, while keeping the volume at 2.0×10⁻³ m³, an ideal gas at '
        '27°C and 1013 hPa is brought to −3°C. Find the pressure then.\n'
        '※Take 0°C as 273 K.',
    hint:
        'The volume has not changed. The ratio of pressure to absolute '
        'temperature is kept. A Celsius temperature cannot be used in the ratio.',
    approach: "Use Gay-Lussac's law, P/T = constant.",
    firstStep: '1013 / 300 = P / 270.',
    explanation:
        "For an isochoric change, Gay-Lussac's law is P/T = constant. "
        '27°C is 27 + 273 = 300 K, and −3°C is −3 + 273 = 270 K. '
        '1013 / 300 = P / 270. '
        'P = 1013 × 270 / 300 = 1013 × 0.90 = 911.7 hPa.',
  ),
  '2eef6ac4-67da-439f-b4fa-d6436a743eb8': ProblemTranslation(
    theme: "Adiabatic change (Poisson's equation)",
    title: 'Temperature after compressing with no heat exchange',
    statement:
        'As shown, with no heat exchanged with the surroundings, air at 27°C '
        'and volume 5.0×10⁻³ m³ is compressed to 1.0×10⁻³ m³. Find the '
        'temperature then, in K.\n'
        '※Take 0°C as 273 K, γ = 1.4, and 5^{0.4} = 1.9.',
    hint:
        'There is no heat exchange with the surroundings. Look at the volume '
        'ratio and the initial absolute temperature.',
    approach: "Use Poisson's equation, T V^{γ−1} = constant.",
    firstStep: 'T × (1.0×10⁻³)^{0.4} = 300 × (5.0×10⁻³)^{0.4}.',
    explanation:
        "For an adiabatic change, Poisson's equation is T V^{γ−1} = constant. "
        'γ = 1.4, so γ−1 = 0.4. '
        '27°C is 27 + 273 = 300 K. '
        'The volume ratio is 5.0×10⁻³ / 1.0×10⁻³ = 5. '
        'T × (1.0×10⁻³)^{0.4} = 300 × (5.0×10⁻³)^{0.4}. '
        'T = 300 × 5^{0.4}. '
        'With 5^{0.4} = 1.9, T = 300 × 1.9 = 570 K.',
  ),
  '6dbf478a-bb30-40a4-bacb-c7c1ddd5b550': ProblemTranslation(
    theme: 'Internal energy of a gas',
    title: 'Pressure of a gas after opening the stopcock',
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
        '(3/2)×1519.5×3.0×10⁻³ + (3/2)×1013×2.0×10⁻³ = (3/2) P × 5.0×10⁻³.',
    explanation:
        'For a monatomic ideal gas, U = (3/2) nRT = (3/2) pV. '
        'While the stopcock is open there is no heat exchange with the outside, '
        'and the vessel volumes do not change, so there is no work on the outside. '
        'The sum of internal energies is therefore unchanged. '
        '(3/2)×1519.5×3.0×10⁻³ + (3/2)×1013×2.0×10⁻³ = (3/2) P × 5.0×10⁻³. '
        '1519.5×3.0 + 1013×2.0 = P × 5.0. '
        '4558.5 + 2026 = 5.0 P. '
        'P = 6584.5 / 5.0 = 1316.9 hPa.',
  ),
  'c6d333a8-fdff-45e6-ae3d-d576394a8f58': ProblemTranslation(
    theme: 'Molar heat capacity of a diatomic ideal gas',
    title: 'Temperature of a gas after opening the stopcock',
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
    firstStep: '(5/2)×0.20×R×293 + (5/2)×0.10×R×353 = (5/2)×(0.20+0.10)×R×T.',
    explanation:
        'For a diatomic ideal gas the molar heat capacity at constant volume '
        'is C_V = (5/2) R, so U = n C_V T = (5/2) nRT. '
        'While the stopcock is open there is no heat exchange with the outside, '
        'and the vessel volumes do not change, so there is no work on the outside. '
        'The sum of internal energies is therefore unchanged, and so is the '
        'total amount of substance. '
        '(5/2)×0.20×R×293 + (5/2)×0.10×R×353 = (5/2)×(0.20+0.10)×R×T. '
        '0.20×293 + 0.10×353 = 0.30 T. '
        '58.6 + 35.3 = 0.30 T. '
        'T = 93.9 / 0.30 = 313 K.',
  ),
  '680f161b-8039-4d8b-97ac-54d641bf875e': ProblemTranslation(
    theme: 'Period of vertical-spring SHM',
    title: 'Period of a mass hanging from a spring',
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
    title: 'Period of a pendulum swung through a small angle',
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
    title: 'Orbital period of a body farther from the Sun',
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
    title: 'Period of the loudness from two tuning forks',
    statement:
        'As shown, the tuning forks on the left and right were sounded '
        'together, and between them the loudness repeatedly grew stronger '
        'and weaker. Find the period of this repetition.',
    hint:
        'The two tuning forks have slightly different frequencies. The '
        'interval at which the loudness repeats is fixed by that difference.',
    approach: 'Use the beat period T = 1/|f1 − f2|.',
    firstStep: 'T = 1/|104 − 100|.',
    explanation:
        'The beat frequency is |f1 − f2|. The period is its reciprocal, so '
        'T = 1/|f1 − f2|. T = 1/|104 − 100| = 1/4 = 0.25 s.',
  ),
  'ab68af64-b6f1-4a0b-b27d-9c8da85c2075': ProblemTranslation(
    theme: 'Springs in series',
    title: 'Extension of two springs connected in series',
    statement:
        'As shown, two springs are connected in series from the ceiling, and '
        'a mass is hung from the lower end and left at rest. Find the '
        'extension of the springs as a whole from their natural length.\n'
        '※Take the magnitude of gravitational acceleration to be 9.8 m/s².',
    hint:
        'The two springs form one path. The extension of the whole is the '
        'extensions of the two springs put together.',
    approach: 'Use the series spring constant, 1/k = 1/k1 + 1/k2.',
    firstStep: '1/k = 1/49 + 1/98.',
    explanation:
        'For springs in series, 1/k = 1/k1 + 1/k2. '
        '1/k = 1/49 + 1/98 = 2/98 + 1/98 = 3/98, so k = 98/3 N/m. '
        'The mass is at rest, so mg = kx. '
        '1.0 × 9.8 = (98/3) x. x = 9.8 × 3 / 98 = 0.30 m.',
  ),
  '355ab9b8-5510-4ab9-be24-4ffb0e0d3d2a': ProblemTranslation(
    theme: 'Springs in parallel',
    title: 'Extension of two springs connected in parallel',
    statement:
        'As shown, two springs are connected in parallel from the ceiling, '
        'and a mass is hung from the lower end and left at rest. Find the '
        'extension of the springs from their natural length.\n'
        '※Take the magnitude of gravitational acceleration to be 9.8 m/s².',
    hint:
        'The two springs are connected so that their extensions are the same. '
        'The weight is shared by the two springs.',
    approach: 'Use the parallel spring constant, k = k1 + k2.',
    firstStep: 'k = 49 + 147.',
    explanation:
        'For springs in parallel, k = k1 + k2. '
        'k = 49 + 147 = 196 N/m. '
        'The mass is at rest, so mg = kx. '
        '2.0 × 9.8 = 196 x. x = 19.6 / 196 = 0.10 m.',
  ),
  '16e3da14-71f7-4691-9997-ee15a8209c5e': ProblemTranslation(
    theme: 'Closed-pipe resonance with end correction',
    title: 'Speed of sound from two resonances in a pipe',
    statement:
        'As shown, a 430 Hz tuning fork was sounded near the upper end of a '
        'cylinder while the water level in the cylinder was slowly changed. '
        'Resonance occurred when the distance from the upper end to the water '
        'surface was 18.5 cm and when it was 58.5 cm, and not between them. '
        'From this fact, calculate the speed of sound theoretically.',
    hint:
        'There are two lengths where resonance occurred, and none between '
        'them. Look at the water surface and just outside the upper end.',
    approach:
        'Use closed-pipe resonance. The difference of neighboring resonance '
        'lengths is λ/2, and the end correction cancels in that difference.',
    firstStep: '58.5 cm − 18.5 cm = λ/2.',
    explanation:
        'In closed-pipe resonance the water surface is a node and the '
        'antinode lies outside the open end. With end correction Δ, '
        'l + Δ = (2n − 1)λ/4. For neighboring resonances the difference '
        'cancels Δ, so λ/2 = 58.5 cm − 18.5 cm = 40.0 cm = 0.400 m, and '
        'λ = 0.800 m. The speed of sound is V = fλ = 430 × 0.800 = 344 m/s.',
  ),
  '6970d4b5-abcd-4825-a0fd-fc210892bc2f': ProblemTranslation(
    theme: 'Equation of state of an ideal gas',
    title: 'Mass of 1 m³ of air',
    statement:
        'There is air in which the amount-of-substance ratio of oxygen to '
        'nitrogen is 1:3. Find the mass of 1.0 m³ of this air at 300 K and '
        '997.2 hPa.\n'
        '※Treat it as an ideal gas. Take the molecular weight of oxygen to '
        'be 32, that of nitrogen to be 28, the gas constant to be '
        'R = 8.31 J/(mol·K), and 997.2 hPa = 9.972×10⁴ Pa.',
    hint:
        'Pressure, volume, and temperature are all fixed, and nothing is '
        'changing from a before to an after. The proportion of oxygen and '
        'nitrogen fixes the mass of 1 mol.',
    approach: 'Use the ideal-gas equation of state, PV = nRT.',
    firstStep: '9.972×10⁴ × 1.0 = n × 8.31 × 300.',
    explanation:
        'The ideal-gas equation of state is PV = nRT. '
        'The mass m and the amount of substance n are related by the molar '
        'mass M through m = nM. The amount-of-substance ratio of oxygen to '
        'nitrogen is 1:3, so '
        'M = (1×32 + 3×28)/(1+3) = 116/4 = 29 g/mol = 2.9×10⁻² kg/mol. '
        '9.972×10⁴ × 1.0 = n × 8.31 × 300. '
        '8.31 × 300 = 2493. '
        'n = 9.972×10⁴ / 2493 = 40 mol. '
        'm = 40 × 2.9×10⁻² = 1.16 kg.',
  ),
  '3f04e9ee-5b10-44b3-959a-8066a139be9d': ProblemTranslation(
    theme: 'Velocity in uniformly accelerated motion',
    title: 'Speed of a dropped object just before it hits the ground',
    statement:
        'As shown, an object was gently released from a height of 0.90 m. Find its '
        'speed just before it reaches the ground.\n'
        '※Take the magnitude of gravitational acceleration to be 9.8 m/s², '
        'and neglect air resistance.',
    hint:
        'The speed at the moment of release is 0, and the distance of the '
        'fall is known. The magnitude of the acceleration during the fall '
        'does not change.',
    approach:
        'Use the velocity formula for uniformly accelerated motion, '
        'v² − v₀² = 2ax.',
    firstStep: 'v² − 0 = 2 × 9.8 × 0.90.',
    explanation:
        'Take downward as positive. For uniformly accelerated motion from '
        'rest, v² − v₀² = 2ax. With a = 9.8 m/s², x = 0.90 m, and v₀ = 0, '
        'v² − 0 = 2 × 9.8 × 0.90. v² = 17.64. v = 4.2 m/s.',
  ),
  '3587cf2f-0e4c-44bf-a255-4413086cf0c9': ProblemTranslation(
    theme: 'Position in uniformly accelerated motion',
    title: 'Time for a dropped object to reach the ground',
    statement:
        'As shown, an object was gently released from a height of 4.9 m. Find the time '
        'until it reaches the ground.\n'
        '※Take the magnitude of gravitational acceleration to be 9.8 m/s², '
        'and neglect air resistance.',
    hint:
        'The speed at the moment of release is 0, and the distance of the '
        'fall is known. What is asked is the time until it reaches the ground.',
    approach:
        'Use the position formula for uniformly accelerated motion, '
        'x = v₀t + (1/2)at².',
    firstStep: '4.9 = 0 × t + (1/2) × 9.8 × t².',
    explanation:
        'Take downward as positive. The position in uniformly accelerated '
        'motion is x = v₀t + (1/2)at². With x = 4.9 m, v₀ = 0, and '
        'a = 9.8 m/s², 4.9 = 0 × t + (1/2) × 9.8 × t². '
        '4.9 = 4.9 t². t² = 1.0. t = 1.0 s.',
  ),
  '03565785-cd7a-4353-bd44-ff3879ea6935': ProblemTranslation(
    theme: 'Gravitational field due to universal gravitation',
    title: 'Geostationary satellite altitude',
    statement:
        'As shown, a satellite moves in a circle above the equator with the '
        'same angular velocity as the rotation of the Earth. Find its altitude '
        'above the surface.\n'
        '※Take the radius of the Earth to be 6.4×10⁶ m, the magnitude of '
        'the gravitational acceleration at the surface to be 10 m/s², and '
        'the angular velocity of the Earth\'s rotation to be 8.0×10⁻⁵ rad/s.',
    hint:
        'It keeps moving with the same angular velocity as the rotation of '
        'the Earth. The gravitational acceleration at the surface and the '
        'radius of the Earth are given.',
    approach:
        'Use the fact that the gravitational field GM/r² equals the '
        'centripetal acceleration rω².',
    firstStep: '10 × (6.4×10⁶)² / r² = r × (8.0×10⁻⁵)².',
    explanation:
        'The gravitational field due to universal gravitation is GM/r². '
        'At the surface, r = R and this magnitude is g, so GM = g R². '
        'For a geostationary satellite this field equals the centripetal '
        'acceleration rω². g R² / r² = r ω². '
        'r³ = g R² / ω² = 10 × (6.4×10⁶)² / (8.0×10⁻⁵)². '
        '(6.4×10⁶)² = 4.096×10¹³ and (8.0×10⁻⁵)² = 6.4×10⁻⁹. '
        'r³ = 10 × 4.096×10¹³ / 6.4×10⁻⁹ = 6.4×10²². '
        '6.4×10²² = 64×10²¹ = (4.0×10⁷)³, so r = 4.0×10⁷ m. '
        'The altitude above the surface is '
        'h = r − R = 4.0×10⁷ − 6.4×10⁶ = 3.36×10⁷ m.',
  ),
  'ad238071-a49c-4825-99a7-29c217b9fd0c': ProblemTranslation(
    theme: 'Definition of capacitance [F]',
    title: 'Charge stored on a capacitor',
    statement: 'Find the charge stored on the capacitor in the figure.',
    hint:
        'The capacitance and the applied voltage are given. The stored '
        'charge is fixed by those two.',
    approach: 'Use the definition of capacitance, Q = CV.',
    firstStep: 'Q = 1000×10⁻⁶ × 18.',
    explanation:
        'The definition of capacitance is C = Q/V, that is, Q = CV. '
        '1000 μF = 1000×10⁻⁶ F = 1.0×10⁻³ F. '
        'Q = 1.0×10⁻³ × 18 = 1.8×10⁻² C.',
  ),
  '990f59e0-b900-4224-8c81-42e9d3e147c7': ProblemTranslation(
    theme: 'Capacitance of a parallel-plate capacitor',
    title: 'Capacitance of a parallel-plate capacitor in vacuum',
    statement:
        'As shown in the figure, two square plates are placed parallel to '
        'each other. The space between the plates is vacuum. Find the '
        'capacitance.\n'
        '※Take the permittivity of vacuum to be 8.85×10⁻¹² F/m.',
    hint:
        'The area of the plates and the separation are given. The space '
        'between them is vacuum, and the permittivity is given.',
    approach:
        'Use the capacitance of a parallel-plate capacitor, C = ε₀ S / d.',
    firstStep: 'C = 8.85×10⁻¹² × (0.10)² / 1.0×10⁻³.',
    explanation:
        'The capacitance of a parallel-plate capacitor is C = ε₀ S / d. '
        'Each plate is a square of side 10 cm = 0.10 m, so '
        'S = 0.10 × 0.10 = 1.0×10⁻² m². The separation is '
        '1 mm = 1.0×10⁻³ m. '
        'C = 8.85×10⁻¹² × 1.0×10⁻² / 1.0×10⁻³ = 8.85×10⁻¹¹ F.',
  ),
  'f5c795da-e888-4d9a-bb13-03b190638904': ProblemTranslation(
    theme: 'Permittivity and relative permittivity',
    title: 'Capacitance of a capacitor filled with paper',
    statement:
        'As shown in the figure, paper fills the space between two square '
        'plates. Find the capacitance.\n'
        '※Take the permittivity of vacuum to be 8.85×10⁻¹² F/m.',
    hint:
        'Paper fills the space, and its relative permittivity is given. '
        'The area of the plates and the thickness of the paper are also given.',
    approach:
        'From the relation between permittivity and relative permittivity, '
        'use C = ε_r ε₀ S / d.',
    firstStep: 'C = 2.0 × 8.85×10⁻¹² × (0.10)² / 1.0×10⁻⁴.',
    explanation:
        'The relation between permittivity and relative permittivity is '
        'ε = ε_r ε₀. When paper fills the space between the plates, the '
        'capacitance is C = ε S / d = ε_r ε₀ S / d. Each plate is a square '
        'of side 10 cm = 0.10 m, so S = 0.10 × 0.10 = 1.0×10⁻² m². The '
        'paper is 0.1 mm = 1.0×10⁻⁴ m thick, and that thickness is the '
        'separation d. '
        'C = 2.0 × 8.85×10⁻¹² × 1.0×10⁻² / 1.0×10⁻⁴ = 1.77×10⁻⁹ F.',
  ),
  '2c769ccf-20fe-4de8-a0dc-f98eb5d7e824': ProblemTranslation(
    theme: 'Combined capacitance of capacitors',
    title: 'Capacitance of a capacitor with a metal plate inside',
    statement:
        'As shown in the figure, a metal plate of the same size is inserted '
        'between two square plates, parallel to them. The gaps are vacuum. '
        'Find the capacitance.\n'
        '※Take the permittivity of vacuum to be 8.85×10⁻¹² F/m.',
    hint:
        'The metal plate divides the space into two gaps. There is no '
        'electric field inside the metal. The area of the plates and the '
        'two separations are given.',
    approach: 'Use the series combination 1/C = 1/C₁ + 1/C₂.',
    firstStep: '1/C = (2.0×10⁻⁴ + 3.0×10⁻⁴) / (8.85×10⁻¹² × (0.10)²).',
    explanation:
        'The combined capacitance of capacitors in series is '
        '1/C = 1/C₁ + 1/C₂. The metal plate between the plates divides the '
        'space into two parallel-plate capacitors. There is no electric '
        'field inside the metal, so the two capacitors are in series. '
        'Thus 1/C = (d₁ + d₂) / (ε₀ S). Each plate is a square of side '
        '10 cm = 0.10 m, so S = 0.10 × 0.10 = 1.0×10⁻² m². '
        'd₁ = 0.2 mm = 2.0×10⁻⁴ m and d₂ = 0.3 mm = 3.0×10⁻⁴ m, so '
        'd₁ + d₂ = 5.0×10⁻⁴ m. '
        'C = 8.85×10⁻¹² × 1.0×10⁻² / 5.0×10⁻⁴ = 1.77×10⁻¹⁰ F.',
  ),
  'ee55e3b5-6de2-4c75-8536-e772727beff3': ProblemTranslation(
    theme: 'Parallel combined capacitance',
    title: 'Capacitance of three capacitors in parallel',
    statement: 'As shown, three capacitors are connected in parallel. Find the capacitance.',
    hint:
        'The three capacitors are each connected between the same two wires. '
        'The voltage across each of them is the same.',
    approach: 'Use the parallel combined capacitance C = C1 + C2 + C3.',
    firstStep: 'C = 10 + 22 + 68.',
    explanation:
        'The combined capacitance of capacitors in parallel is '
        'C = C1 + C2 + C3. The three capacitors share both ends, so they '
        'are in parallel. C = 10 + 22 + 68 = 100 μF.',
  ),
  'ea751b97-55c2-4363-a575-5d8fdc5cc9a7': ProblemTranslation(
    theme: 'Gravitational constant [N·m^2/kg^2]',
    title: 'Measurement of the gravitational constant',
    statement:
        'As shown, a rod is suspended horizontally by a wire at its center. '
        'When the large spheres are put in place, the rod turns and stops. '
        'Find the gravitational constant.\n'
        '※Take the torsion constant of the wire to be 6.7×10⁻⁵ N·m/rad. '
        'The torsion constant is the moment the wire exerts to untwist, when '
        'it is twisted by 1 rad. The twist angle when the rod has stopped is '
        'θ = 1.0×10⁻³ rad. At that stop, the line joining the center of a '
        'large sphere to the center of a small sphere is perpendicular to the '
        'rod. The sizes of the spheres are negligible compared with the '
        'distance between their centers.',
    hint:
        'After the large spheres are in place, the rod has stopped turning. '
        'Look at the twist of the wire and at the positions of the large and '
        'small spheres, about the center of the rod.',
    approach:
        'Use the balance of moments and the law of universal gravitation.',
    firstStep: 'κθ = (GMm / r²) × L.',
    explanation:
        'The magnitude of the universal gravitational force is F = GMm / r². '
        'After the large spheres are in place, the line joining the center of '
        'a large sphere to the center of a small sphere is perpendicular to '
        'the rod. At the two ends these directions are opposite, and both '
        'forces turn the rod the same way. With L the length of the rod, the '
        'moment about the center is 2 × F × (L/2) = FL. At the stopped '
        'position this moment balances the restoring moment κθ of the wire. '
        'κθ = FL = GMmL / r², so G = κθ r² / (MmL). '
        'Substitute κ = 6.7×10⁻⁵ N·m/rad, θ = 1.0×10⁻³ rad, r = 0.20 m, '
        'M = 100 kg, m = 0.40 kg and L = 1.0 m. '
        'r² = (0.20)² = 0.040. The numerator is '
        '6.7×10⁻⁵ × 1.0×10⁻³ × 0.040 = 2.68×10⁻⁹. '
        'The denominator is 100 × 0.40 × 1.0 = 40. '
        'G = 2.68×10⁻⁹ / 40 = 6.7×10⁻¹¹ N·m²/kg².',
  ),
  '4dc4c30e-cd7d-4453-abc4-4f653c9076f3': ProblemTranslation(
    theme: 'Orbital radius from the orbital period',
    title: 'Distance from the Earth to the Moon',
    statement:
        'As shown, the Moon moves in a circle around the Earth. Find the '
        'distance from the center of the Earth to the Moon.\n'
        '※Take the radius of the Earth to be 6.4×10⁶ m, the magnitude of '
        'the gravitational acceleration at the surface to be 9.8 m/s², the '
        'orbital period of the Moon to be 27.3 days, 1 day to be 8.64×10⁴ s, '
        'π = 3.14, and ∛(5.66×10²⁵) = 3.84×10⁸. The mass of the Moon is '
        'negligible compared with the Earth.',
    hint:
        'The Moon keeps moving around the Earth with the given period. The '
        'gravitational acceleration at the surface and the radius of the '
        'Earth are also given.',
    approach:
        'Use Kepler\'s third law, T² = 4π² a³ / GM. Obtain GM from the '
        'gravitational acceleration at the surface.',
    firstStep:
        '(27.3 × 8.64×10⁴)² = 4 × (3.14)² × a³ / (9.8 × (6.4×10⁶)²).',
    explanation:
        'Kepler\'s third law is T² = 4π² a³ / GM. '
        'At the surface the magnitude of the gravitational acceleration is '
        'g = GM / R², so GM = g R². '
        'Therefore T² = 4π² a³ / (g R²). '
        'a³ = g R² T² / (4π²). '
        'T = 27.3 × 8.64×10⁴ = 2.35872×10⁶ s. '
        'R² = (6.4×10⁶)² = 4.096×10¹³. '
        'g R² = 9.8 × 4.096×10¹³ = 4.01408×10¹⁴. '
        'T² = (2.35872×10⁶)² = 5.56356×10¹². '
        'g R² T² = 4.01408×10¹⁴ × 5.56356×10¹² = 2.23325×10²⁷. '
        '4π² = 4 × (3.14)² = 4 × 9.8596 = 39.4384. '
        'a³ = 2.23325×10²⁷ / 39.4384 = 5.66×10²⁵. '
        'With ∛(5.66×10²⁵) = 3.84×10⁸, a = 3.84×10⁸ m.',
  ),
  '1de21279-b406-41f8-a86d-4da5a47293f9': ProblemTranslation(
    theme: 'Projectile range',
    title: 'Initial speed of a long throw',
    statement:
        'As shown, a ball was thrown from the ground at 45° and landed on the '
        'ground 90 m away. Find the speed at which it was thrown, in km/h.\n'
        '※Take the magnitude of gravitational acceleration to be 10 m/s², '
        'and neglect air resistance.',
    hint:
        'The place it was thrown and the place it landed are on the same '
        'ground. The angle with the ground is 45°.',
    approach: 'Use the projectile range R = v₀² sin 2θ / g.',
    firstStep: '90 = v₀² × sin 90° / 10.',
    explanation:
        'For a projectile that returns to the height from which it was '
        'thrown, the range is R = v₀² sin 2θ / g. '
        'With θ = 45°, 2θ = 90° and sin 90° = 1. '
        '90 = v₀² × 1 / 10. '
        'v₀² = 900, so v₀ = 30 m/s. '
        'In km/h this is 30 × 3.6 = 108 km/h.',
  ),
  '2984b8a0-e30c-4106-8dbe-4d790b4bde61': ProblemTranslation(
    theme: 'Central mass from orbital radius and period',
    title: 'Mass of the Sun',
    statement:
        'As shown, the Earth moves in a circle around the Sun. '
        'Find the mass of the Sun.\n'
        '※Take the orbital radius of the Earth to be 1.50×10¹¹ m, '
        'the orbital period to be 365.6 days, 1 day to be 8.64×10⁴ s, '
        'the gravitational constant to be 6.67×10⁻¹¹ N·m²/kg², and π = 3.14. '
        'The mass of the Earth is negligible compared with the Sun.',
    hint:
        'The Earth keeps moving around the Sun with the given radius and '
        'period. The gravitational constant is also given.',
    approach: 'Use Kepler\'s third law, T² = 4π² a³ / GM.',
    firstStep:
        '(365.6 × 8.64×10⁴)² = 4 × (3.14)² × (1.50×10¹¹)³ / (6.67×10⁻¹¹ × M).',
    explanation:
        'Kepler\'s third law is T² = 4π² a³ / GM. '
        'Neglecting the mass of the Earth, M is the mass of the Sun. '
        'M = 4π² a³ / (G T²). '
        'T = 365.6 × 8.64×10⁴ = 3.158784×10⁷ s. '
        'T² = (3.158784×10⁷)² = 9.97791×10¹⁴. '
        'a³ = (1.50×10¹¹)³ = 3.375×10³³. '
        '4π² = 4 × (3.14)² = 4 × 9.8596 = 39.4384. '
        '4π² a³ = 39.4384 × 3.375×10³³ = 1.33105×10³⁵. '
        'G T² = 6.67×10⁻¹¹ × 9.97791×10¹⁴ = 6.65527×10⁴. '
        'M = 1.33105×10³⁵ / 6.65527×10⁴ = 2.0×10³⁰ kg.',
  ),
  '960df344-a24b-4174-821c-9ddbcdce5631': ProblemTranslation(
    theme: 'Equation of state of an ideal gas',
    title: 'Scale drop after pumping out air',
    statement:
        'As shown, dry air in a cylindrical container was pumped out until '
        'the inside was nearly a vacuum. By how many grams does the scale '
        'reading decrease?\n'
        '※Treat the air as an ideal gas. Take the molar mass of dry air '
        'to be 29 g/mol, the gas constant to be R = 8.31 J/(mol·K), '
        'π = 3.14, and 0°C = 273 K. Take the initial pressure to be '
        '1.0×10⁵ Pa. The volume outside the container does not change.',
    hint:
        'The outside of the container has not changed. The scale drops by '
        'the mass of the air that left. The temperature and the volume are '
        'the same before and after.',
    approach:
        'Use the equation of state of an ideal gas, pV = nRT, before and '
        'after the air is pumped out.',
    firstStep: '1.0×10⁵ × V = Δn × 8.31 × 300.',
    explanation:
        'The equation of state of an ideal gas is pV = nRT. '
        'Pumping out to a near vacuum removes essentially all of the air, '
        'so Δn = p V / (R T). The scale drops by Δm = Δn M. '
        'The volume outside the container does not change, so the buoyancy '
        'does not change. '
        '27°C is 27 + 273 = 300 K. '
        'The volume of the cylinder is V = π r² h = 3.14 × (0.050)² × 0.318. '
        '(0.050)² = 0.0025. '
        'V = 3.14 × 0.0025 × 0.318 = 2.4963×10⁻³ m³. '
        'Δm = 1.0×10⁵ × 2.4963×10⁻³ × 29 / (8.31 × 300) '
        '= 7240.77 / 2493 = 2.90 g.',
  ),
};
