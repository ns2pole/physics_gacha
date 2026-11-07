import '../../../models/problem_translation.dart';

const noteArticleTranslationsEn = <String, ProblemTranslation>{
  '12398171-259c-413a-ac28-a86b2cb81ff2': ProblemTranslation(
    theme: 'Doppler effect (source and observer both moving)',
    title: 'Wall speed from the reflected sound',
    statement:
        'As shown, a stationary source emits 3405 Hz, and the sound reflected '
        'from a receding wall is 3395 Hz. Find the speed of the wall in m/s.\n'
        '※Take the speed of sound to be 340 m/s. The source and the observer '
        'are both at rest.',
    hint:
        'For the incoming sound the wall is a moving observer, and for the '
        'returning sound it is a moving source.',
    approach:
        'Use the Doppler effect twice: once toward the wall and once back from it.',
    firstStep: '3395 = 3405 × (340 − u) / (340 + u).',
    explanation:
        'For a stationary observer, a wall receding at speed u returns the '
        'frequency f\' = f (v − u) / (v + u). '
        '3395 = 3405 × (340 − u) / (340 + u). '
        '3395 × (340 + u) = 3405 × (340 − u). '
        'u × (3395 + 3405) = 340 × (3405 − 3395). '
        'u × 6800 = 340 × 10 = 3400. '
        'u = 3400 / 6800 = 0.50 m/s.',
  ),
  '0527566c-8c16-4294-a46c-a1acd1030f51': ProblemTranslation(
    theme: 'Dark fringe of a single slit',
    title: 'First dark fringe of a single slit',
    statement:
        'As shown, light of wavelength 600 nm meets a single slit of width '
        '0.10 mm at a right angle. The first dark fringe is seen on a screen '
        '0.50 m away. Find the distance from the central bright fringe to that '
        'dark fringe, in mm.\n'
        '※The angle is small, so sin θ = tan θ = θ.',
    hint:
        'At the first dark point on the screen, the paths from the two edges '
        'of the slit differ by half a wavelength.',
    approach:
        'The first dark fringe of a single slit satisfies sin θ = λ / d.',
    firstStep: 'sin θ = 600×10⁻⁹ / (0.10×10⁻³).',
    explanation:
        'The first dark fringe of a single slit is sin θ = λ / d. '
        'd = 0.10×10⁻³ = 1.0×10⁻⁴ m and λ = 600×10⁻⁹ = 6.0×10⁻⁷ m. '
        'sin θ = 6.0×10⁻⁷ / 1.0×10⁻⁴ = 6.0×10⁻³. '
        'The angle is small, so θ = 6.0×10⁻³. '
        'The distance on the screen is x = L θ = 0.50 × 6.0×10⁻³ = '
        '3.0×10⁻³ m = 3.0 mm.',
  ),
  '6a8376a3-ce81-44e9-bc20-f12f357ee369': ProblemTranslation(
    theme: 'Path difference and phase of a diffraction grating',
    title: 'First-order bright fringe of a grating',
    statement:
        'As shown, light of wavelength 600 nm meets a grating of spacing '
        '1.0×10⁻⁶ m at a right angle. The first-order bright fringe is seen '
        'on a screen 1.0 m away. Find the distance from the central bright '
        'fringe to that fringe, in cm.\n'
        '※Obtain tan θ from sin θ.',
    hint:
        'A bright fringe forms where the paths through neighboring openings '
        'differ by one wavelength.',
    approach: 'The first-order bright fringe of a grating is d sin θ = λ.',
    firstStep: '1.0×10⁻⁶ × sin θ = 600×10⁻⁹.',
    explanation:
        'The first-order bright fringe of a grating is d sin θ = λ. '
        'sin θ = 600×10⁻⁹ / 1.0×10⁻⁶ = 0.60. '
        'cos θ = √(1 − 0.60²) = √(1 − 0.36) = √0.64 = 0.80. '
        'tan θ = 0.60 / 0.80 = 0.75. '
        'The distance on the screen is x = L tan θ = 1.0 × 0.75 = '
        '0.75 m = 75 cm.',
  ),
  '66546af1-dd8b-42fd-826e-208119255735': ProblemTranslation(
    theme: 'Tension of a string at resonance',
    title: 'Mass that makes the string resonate',
    statement:
        'As shown, a string of linear density 1.0×10⁻³ kg/m is stretched over '
        '0.50 m and driven at 70 Hz in its fundamental mode. Find the mass '
        'hung from the end, in g.\n'
        '※Take the magnitude of gravitational acceleration to be 9.8 m/s². '
        'Ignore every mass except the string.',
    hint:
        'In the fundamental mode with both ends fixed, the length of the string '
        'is half a wavelength.',
    approach:
        'The fundamental frequency of a string fixed at both ends is '
        'f = (1 / 2L) √(T / ρ).',
    firstStep: '70 = (1 / (2 × 0.50)) × √(T / 1.0×10⁻³).',
    explanation:
        'The fundamental frequency with both ends fixed is '
        'f = (1 / 2L) √(T / ρ). T = 4 ρ f² L². '
        'f² = 70² = 4900 and L² = 0.25. '
        'T = 4 × 1.0×10⁻³ × 4900 × 0.25 = 4.9 N. '
        'The hanging mass is M = T / g = 4.9 / 9.8 = 0.50 kg = 500 g.',
  ),
  'a0c33208-8b92-4fb2-8bab-b4b7bb4190d2': ProblemTranslation(
    theme: 'Wave on a string fixed at both ends',
    title: 'Fundamental frequency of a plucked string',
    statement:
        'As shown, a string of linear density 0.40 g/m is stretched over 50 cm '
        'and pulled by a 200 g mass. Find the fundamental frequency in Hz.\n'
        '※Take the magnitude of gravitational acceleration to be 9.8 m/s².',
    hint:
        'Both ends of the string stay still. For the lowest tone, the length '
        'is half a wavelength.',
    approach:
        'The fundamental frequency of a string fixed at both ends is '
        'f = (1 / 2L) √(T / ρ).',
    firstStep: 'T = 0.200 × 9.8.',
    explanation:
        'The fundamental frequency with both ends fixed is '
        'f = (1 / 2L) √(T / ρ). '
        'T = 0.200 × 9.8 = 1.96 N. '
        'ρ = 0.40 g/m = 4.0×10⁻⁴ kg/m and L = 0.50 m. '
        'T / ρ = 1.96 / 4.0×10⁻⁴ = 4900. '
        '√(T / ρ) = 70 m/s. '
        'f = 70 / (2 × 0.50) = 70 / 1.0 = 70 Hz.',
  ),
  '9754d70d-66f6-4c2d-b2fc-2e47ff967a8e': ProblemTranslation(
    theme: 'Period of uniform circular motion',
    title: 'Period of a conical pendulum',
    statement:
        'As shown, a bob on a 2.0 m string moves in a horizontal circle, '
        'keeping an angle of 60° from the vertical. Find the period in s.\n'
        '※Take g = 9.8 m/s², π = 3.14, and √(1.0/9.8) = 0.319.',
    hint:
        'If the angle from the vertical stays constant, the bob moves at '
        'constant speed in a horizontal circle.',
    approach:
        'The period of this uniform circular motion is T = 2π √(L cos θ / g).',
    firstStep: 'T = 2 × 3.14 × √(2.0 × cos 60° / 9.8).',
    explanation:
        'The period of a conical pendulum is T = 2π √(L cos θ / g). '
        'cos 60° = 1/2. '
        'L cos θ / g = 2.0 × 0.50 / 9.8 = 1.0 / 9.8. '
        '√(L cos θ / g) = 0.319. '
        'T = 6.28 × 0.319 = 2.0 s.',
  ),
  '385afc33-7632-45e7-b510-6a09360679d3': ProblemTranslation(
    theme: 'Path difference of two sources',
    title: 'Lowest frequency that sounds quiet',
    statement:
        'As shown, two speakers in phase are 2.0 m and 2.5 m from a point. '
        'Find the lowest frequency that interferes destructively at that point, '
        'in Hz.\n'
        '※Take the speed of sound to be 340 m/s.',
    hint:
        'The sound is weak when the difference of the two paths is an odd '
        'multiple of half a wavelength.',
    approach:
        'The first destructive interference of two sources in phase occurs '
        'when the path difference is λ / 2.',
    firstStep: '2.5 − 2.0 = λ / 2.',
    explanation:
        'The first destructive condition for two sounds in phase is '
        'Δ = λ / 2. Δ = 2.5 − 2.0 = 0.50 m. λ = 2 × 0.50 = 1.0 m. '
        'f = v / λ = 340 / 1.0 = 340 Hz.',
  ),
  'd2bd1250-0b63-4c72-80cb-836221903063': ProblemTranslation(
    theme: 'Temperature coefficient of the speed of sound',
    title: 'Temperature coefficient of the speed of sound',
    statement:
        'As shown, a 500 Hz tuning fork resonates in a closed pipe. The length '
        'from the water surface to the antinode is 16.0 cm at an air temperature '
        'of 10°C and 16.9 cm at 40°C. Find how many m/s the speed of sound '
        'increases when the air temperature rises by 1°C.\n'
        '※The end correction does not depend on temperature. Use the fundamental mode.',
    hint:
        'In the fundamental mode of a closed pipe, the corrected length is a '
        'quarter wavelength. Look at the difference between the two temperatures.',
    approach:
        'The fundamental mode of a closed pipe is v = 4 f (L + Δ). '
        'The correction Δ cancels in the difference.',
    firstStep: 'v₂ − v₁ = 4 × 500 × (0.169 − 0.160).',
    explanation:
        'The fundamental mode of a closed pipe is v = 4 f (L + Δ). '
        'If the end correction does not change with temperature, '
        'v₂ − v₁ = 4 f (L₂ − L₁). '
        'L₂ − L₁ = 0.169 − 0.160 = 0.0090 m. '
        'v₂ − v₁ = 4 × 500 × 0.0090 = 18 m/s. '
        'The air temperature difference is 40 − 10 = 30°C. '
        'The increase per 1°C is 18 / 30 = 0.60 m/s.',
  ),
  'c903ff0f-db40-4916-8ed4-5c4a656dc9f1': ProblemTranslation(
    theme: 'Mechanical energy of simple harmonic motion',
    title: 'Speed of a vertical spring at its natural length',
    statement:
        'As shown, a light spring of constant 29.4 N/m hangs vertically with a '
        '100 g mass on its lower end. The mass is pulled 0.20 m below the '
        'natural length and released from rest. Find its speed as it passes '
        'the natural length, in m/s.\n'
        '※Take g = 9.8 m/s².',
    hint:
        'Between the release point and the natural length, spring energy trades '
        'places with the height and the speed of the mass.',
    approach:
        'Use conservation of mechanical energy between the release point and '
        'the natural length.',
    firstStep:
        '(1/2) × 29.4 × (0.20)² = (1/2) × 0.100 × v² + 0.100 × 9.8 × 0.20.',
    explanation:
        'Mechanical energy is conserved. With height measured from the natural '
        'length, the release point has (1/2) k x² − m g x and the natural '
        'length has (1/2) m v². '
        '(1/2) × 29.4 × 0.040 = 0.588. '
        'm g x = 0.100 × 9.8 × 0.20 = 0.196. '
        '(1/2) m v² = 0.588 − 0.196 = 0.392. '
        'v² = 0.784 / 0.100 = 7.84. v = 2.8 m/s.',
  ),
  '7da18bc0-3810-4a32-8930-0e17ba16efce': ProblemTranslation(
    theme: 'Work and energy',
    title: 'Speed of the object on the table',
    statement:
        'As shown, a 200 g object on a smooth table is connected over a pulley '
        'to a 200 g hanging mass and released from rest. Find the speed of the '
        'object on the table after it has moved 0.80 m, in m/s.\n'
        '※The table is fixed. Take g = 9.8 m/s². The string and the pulley '
        'are light, and there is no friction.',
    hint: 'The only force that does work while they move is the weight of the descending mass.',
    approach: 'Use work and energy for the two objects together.',
    firstStep: '0.200 × 9.8 × 0.80 = (1/2) × (0.200 + 0.200) × v².',
    explanation:
        'The work done by gravity on the hanging mass becomes the kinetic '
        'energy of both objects. W = 0.200 × 9.8 × 0.80 = 1.568 J. '
        '(1/2) × 0.400 × v² = 1.568. 0.200 × v² = 1.568. '
        'v² = 7.84. v = 2.8 m/s.',
  ),
  '19776c8b-24cd-4aaf-95ab-5a5097ed7055': ProblemTranslation(
    theme: 'Elastic energy of a spring',
    title: 'Speed after releasing a horizontal spring',
    statement:
        'As shown, on a smooth horizontal surface a light spring of constant '
        '4.0 N/m is compressed by 0.30 m and a 40 g object is released from '
        'rest. Find the speed when the spring returns to its natural length, '
        'in m/s.\n'
        '※The table is fixed.',
    hint:
        'The surface is horizontal and frictionless, so only the compression '
        'of the spring changes the speed.',
    approach:
        'The elastic energy of the spring becomes the kinetic energy of the object.',
    firstStep: '(1/2) × 4.0 × (0.30)² = (1/2) × 0.040 × v².',
    explanation:
        'Elastic energy is (1/2) k x² and kinetic energy is (1/2) m v². '
        '(1/2) × 4.0 × 0.090 = (1/2) × 0.040 × v². '
        '0.180 = 0.020 v². v² = 9.0. v = 3.0 m/s.',
  ),
  '80b5bc83-b93e-402a-b658-be4cc879795a': ProblemTranslation(
    theme: 'Speed of a pendulum at the bottom',
    title: 'Speed of a pendulum at the bottom',
    statement:
        'As shown, a pendulum of length 0.20 m is raised 60° from the vertical '
        'and released from rest. Find the speed at the bottom, in m/s.\n'
        '※Take g = 9.8 m/s². Ignore the mass of the string and friction.',
    hint:
        'The string is perpendicular to the motion, so it does no work. '
        'Height turns into speed.',
    approach:
        'Use conservation of mechanical energy between the release point and the bottom.',
    firstStep: '0.20 × (1 − cos 60°) × 9.8 = (1/2) v².',
    explanation:
        'Mechanical energy is conserved. With height measured from the bottom, '
        'the release height is L (1 − cos 60°). cos 60° = 1/2, so the height '
        'is 0.20 × 0.50 = 0.10 m. m g h = (1/2) m v², so '
        'v² = 2 × 9.8 × 0.10 = 1.96. v = 1.4 m/s.',
  ),
  'd09b53dc-125f-4a38-8908-9911d635cb8e': ProblemTranslation(
    theme: 'Balance of moments',
    title: 'Force that lifts one end of a block',
    statement:
        'As shown, one end of a uniform 200 g block stays on the floor while '
        'the other end is lifted vertically and held at rest. Find the '
        'magnitude of the lifting force, in N.\n'
        '※Take g = 9.8 m/s².',
    hint: 'About the end on the floor, the force at that end has no moment.',
    approach: 'Use the balance of moments about the end that stays on the floor.',
    firstStep: 'F × L = 0.200 × 9.8 × (L / 2).',
    explanation:
        'Moments balance about the end on the floor. The weight acts at the '
        'center, and the lifting force acts at the other end. '
        'F L = m g (L / 2). F = m g / 2 = 0.200 × 9.8 / 2 = 1.96 / 2 = 0.98 N.',
  ),
  'b5640d96-7b77-4993-ac9a-b8969461b744': ProblemTranslation(
    theme: 'Definition of the center of mass [m]',
    title: 'Center of mass of a disk with a hole',
    statement:
        'As shown, a circle of half the radius is cut from a uniform disk of '
        'radius 10.2 cm. The center of the hole is half a radius away from '
        'the original center. How many cm toward the side opposite the hole '
        'does the center of mass of the remainder shift?',
    hint:
        'Treat the original disk and the hole as two disks, one with positive '
        'mass and one with negative mass.',
    approach:
        'Use the definition of the center of mass, subtracting the hole from the original disk.',
    firstStep: 'x = (0 − (1/4) × (R / 2)) / (1 − 1/4).',
    explanation:
        'The center of mass is the mass-weighted average position. '
        'The hole has 1/4 of the area, so its mass is M / 4. '
        'Its center is R / 2 toward the hole from the original center. '
        'The remaining mass is 3M / 4. '
        'x = (M × 0 − (M / 4) × (R / 2)) / (3M / 4) = −R / 6. '
        'The shift away from the hole is R / 6 = 10.2 / 6 = 1.7 cm.',
  ),
  'e5bc3b07-2a24-49d0-9cf3-f6e03c9b6c8f': ProblemTranslation(
    theme: 'Center of mass of a cut sheet',
    title: 'Horizontal position of a cut sheet',
    statement:
        'As shown, a 12 cm by 8.0 cm rectangle is cut from the upper right '
        'of a uniform 24 cm by 16 cm rectangle. Find the distance from the '
        'left edge to the center of mass of the remainder, in cm.',
    hint:
        'Subtract the center of the removed rectangle from the center of the '
        'original rectangle, weighted by area.',
    approach:
        'Use the definition of the center of mass, subtracting the removed part.',
    firstStep: 'x = (12 − (1/4) × 18) / (3/4).',
    explanation:
        'The original center is 12 cm from the left edge. '
        'The removed part has 1/4 of the area, and its center is 18 cm '
        'from the left edge. The remaining area is 3/4. '
        'x = (12 − 0.25 × 18) / 0.75. '
        '0.25 × 18 = 4.5. '
        'x = (12 − 4.5) / 0.75 = 7.5 / 0.75 = 10 cm.',
  ),
  'fccf9e77-372c-4c34-b17d-9cafc2d339b5': ProblemTranslation(
    theme: 'Boundary between sliding and tipping',
    title: 'Height at the boundary between sliding and tipping',
    statement:
        'As shown, a uniform block of width 6.0 cm rests on a horizontal floor '
        'and is pushed horizontally on its side. The coefficient of kinetic '
        'friction is 0.20, and the coefficient of static friction is the same. '
        'Above this height the block tips; below it, the block slides. '
        'Find the boundary height in cm.',
    hint:
        'Just as sliding starts, the friction from the floor equals the maximum '
        'static friction. About the lower edge, that is when tipping starts.',
    approach:
        'Sliding uses the maximum static friction. Tipping uses the balance of '
        'moments about the lower edge.',
    firstStep: 'h = 6.0 / (2 × 0.20).',
    explanation:
        'The force that starts sliding is F = μ m g. About the lower edge, '
        'the height where the moment F h balances the moment of the weight '
        'm g (b / 2) is the boundary. μ m g h = m g (b / 2). '
        'h = b / (2μ) = 6.0 / (2 × 0.20) = 6.0 / 0.40 = 15 cm.',
  ),
  'b7c1e735-bbda-461c-a72e-eff2609a5ab1': ProblemTranslation(
    theme: "Buoyancy (Archimedes' principle)",
    title: 'Length submerged in salt water',
    statement:
        'As shown, a uniform cylinder of length 20 cm, mass 31.4 g, and radius '
        '1.0 cm floats vertically in salt water of density 1.25 g/cm³. '
        'Find the length below the surface, in cm.\n'
        '※Take π = 3.14.',
    hint:
        'The cylinder is floating at rest, so its weight equals the weight of '
        'the salt water displaced by the submerged part.',
    approach: 'Buoyancy equals the weight of the displaced fluid.',
    firstStep: '31.4 = 1.25 × (3.14 × 1.0² × l).',
    explanation:
        'While floating at rest, the mass equals the mass of salt water displaced. '
        'The cross section is π r² = 3.14 × 1.0 = 3.14 cm². '
        '31.4 = 1.25 × 3.14 × l. 3.925 × l = 31.4. '
        'l = 31.4 / 3.925 = 8.0 cm.',
  ),
  '760c69d1-1a7e-41f8-b18f-8b7ac39735a4': ProblemTranslation(
    theme: 'Gravitational acceleration at the surface [m/s^2]',
    title: 'Gravity at one Earth-radius from the surface',
    statement:
        'Treat Earth as a sphere of radius 6.4×10⁶ m. Find the magnitude of '
        'gravitational acceleration at a point one Earth radius above the '
        'surface, in m/s².\n'
        '※Take the surface value to be 9.8 m/s². Ignore the rotation of Earth.',
    hint:
        'Away from the surface, the distance from the center of Earth is longer '
        'than the radius.',
    approach:
        'Surface gravity is g = GM / R². At height h the distance is R + h.',
    firstStep: "g' = 9.8 × (6.4×10⁶)² / (6.4×10⁶ + 6.4×10⁶)².",
    explanation:
        'Gravitational acceleration is inversely proportional to the square of '
        "the distance from the center. g' = g / (1 + h / R)². "
        'With h = R, 1 + h / R = 2. (1 + h / R)² = 4. '
        "g' = 9.8 / 4 = 2.45 m/s².",
  ),
  '3161b116-b09a-4d0b-b92d-44cd0d46a4a4': ProblemTranslation(
    theme: 'Kinetic friction',
    title: 'Coefficient of kinetic friction',
    statement:
        'As shown, a 400 g object is tied by a string to a spring scale and '
        'pulled across a horizontal floor at constant speed. The scale reads '
        '0.98 N. Find the '
        'coefficient of kinetic friction.\n'
        '※Take g = 9.8 m/s².',
    hint:
        'The speed is constant, so horizontally the pulling force balances kinetic friction.',
    approach:
        'Kinetic friction is f = μ N, and on a horizontal floor the normal force equals the weight.',
    firstStep: '0.98 = μ × 0.400 × 9.8.',
    explanation:
        'At constant speed the pulling force balances kinetic friction. '
        'f = μ m g. μ = 0.98 / (0.400 × 9.8) = 0.98 / 3.92 = 0.25.',
  ),
  'b29b25dc-cde4-4e27-ade8-bfb66af29ad3': ProblemTranslation(
    theme: 'Maximum static friction',
    title: 'Coefficient of static friction',
    statement:
        'As shown, a 400 g object on a horizontal floor is tied by a string to '
        'a spring scale and pulled slowly horizontally. The reading at the instant it starts to move '
        'is 1.96 N. Find the coefficient of static friction.\n'
        '※Take g = 9.8 m/s².',
    hint:
        'At the instant motion starts, the pulling force has reached the maximum static friction.',
    approach:
        'Maximum static friction is f = μ N, and on a horizontal floor the normal force equals the weight.',
    firstStep: '1.96 = μ × 0.400 × 9.8.',
    explanation:
        'The force at the instant motion starts equals the maximum static friction. '
        'f = μ m g. μ = 1.96 / (0.400 × 9.8) = 1.96 / 3.92 = 0.50.',
  ),
  'b775e759-f47a-40ad-9506-762bd7e1b158': ProblemTranslation(
    theme: 'Centrifugal force',
    title: 'Spring reading on a turntable',
    statement:
        'As shown, a 100 g mass is tied by a spring 0.20 m from the center of '
        'a turntable and turns with the table at a period of 0.628 s. The mass '
        'stays at rest on the table. Find the spring reading in N.\n'
        '※Take π = 3.14. The mass does not move relative to the table.',
    hint:
        'To a person turning with the table, the mass is at rest, and the '
        'outward force balances the spring.',
    approach:
        'The centrifugal force is m ω² r. While the mass is at rest on the '
        'turntable, it balances the spring force.',
    firstStep: 'F = 0.100 × (2 × 3.14 / 0.628)² × 0.20.',
    explanation:
        'The centrifugal force is F = m ω² r. '
        'ω = 2π / T = 6.28 / 0.628 = 10 rad/s. ω² = 100. '
        'F = 0.100 × 100 × 0.20 = 2.0 N.',
  ),
  '04aa630e-a4c3-46ee-918c-531536db9665': ProblemTranslation(
    theme: 'Inertial force in an accelerating frame',
    title: 'Spring reading in a rising elevator',
    statement:
        'As shown, a 200 g mass hangs from a spring scale in an elevator '
        'accelerating upward at 1.0 m/s². Find the scale reading in N.\n'
        '※Take g = 9.8 m/s².',
    hint:
        'Inside the elevator the mass looks at rest. Upward acceleration adds '
        'a downward force.',
    approach: 'In an accelerating box, the inertial force −m a appears.',
    firstStep: 'F − 0.200 × 9.8 − 0.200 × 1.0 = 0.',
    explanation:
        'In a frame accelerating upward with the elevator, an inertial force '
        'm a acts downward. The mass looks at rest, so the spring force is the '
        'sum of the weight and the inertial force. '
        'F = m (g + a) = 0.200 × (9.8 + 1.0) = 0.200 × 10.8 = 2.16 N.',
  ),
  'dc2ea26c-266e-4441-96b7-a9a514e3b799': ProblemTranslation(
    theme: 'Gravitational potential energy near the ground',
    title: 'Height reached beyond the nail',
    statement:
        'As shown, a pendulum is released from rest 12 cm above the bottom. '
        'A nail is not directly below the bottom, and the string catches on it '
        'partway. After the string catches, how many cm above the bottom does '
        'the bob rise?\n'
        '※The string does not go slack, and the nail takes no energy.',
    hint:
        'The nail only changes the direction of the string. It adds no force '
        'along the motion of the bob.',
    approach:
        'The sum of gravitational potential energy and kinetic energy is conserved.',
    firstStep: "m g h = m g h'.",
    explanation:
        'The nail does no work, so mechanical energy is conserved. '
        'At release the speed is 0 and the height is 12 cm above the bottom. '
        "At the height h' on the other side where the speed is again 0, "
        "m g × 12 = m g h'. h' = 12 cm.",
  ),
  '264dc236-782b-4ba0-9d39-13c94f7ea889': ProblemTranslation(
    theme: 'Tension decrease in water',
    title: 'How much a spring scale drops in salt water',
    statement:
        'As shown, an object of mass 100 g and volume 40 cm³ hangs from a '
        'spring scale and is lowered into salt water. By how many grams does '
        'the reading drop compared with air?\n'
        '※Take the density of the salt water to be 1.25 g/cm³. The object is '
        'fully under the liquid. Ignore buoyancy in air.',
    hint:
        'In the liquid, an upward force equal to the weight of the displaced '
        'salt water is added.',
    approach:
        'Buoyancy equals the weight of the displaced salt water, and the scale '
        'reading drops by that amount.',
    firstStep: 'Δm = 1.25 × 40.',
    explanation:
        'Buoyancy equals the weight of the displaced salt water. '
        'The mass of displaced salt water is 1.25 × 40 = 50 g. '
        'The scale reading drops by the corresponding 50 g.',
  ),
  'fb52940c-6b53-4c80-a4a3-639e2aa650ef': ProblemTranslation(
    theme: 'Tension of a pendulum at the bottom',
    title: 'Tension of a pendulum at the bottom',
    statement:
        'As shown, a 100 g bob is raised 60° from the vertical and released '
        'from rest. Find the tension in the string at the bottom, in N.\n'
        '※Take g = 9.8 m/s². Ignore the mass of the string and friction.',
    hint:
        'At the bottom, the difference between tension and weight is the centripetal force.',
    approach:
        'Find the speed from conservation of energy, then the tension from the equation of motion at the bottom.',
    firstStep: 'T − 0.100 × 9.8 = 0.100 × v² / L.',
    explanation:
        'With height measured from the bottom, the release height is '
        'L (1 − cos 60°) = L / 2. v² = 2 g (L / 2) = g L. '
        'At the bottom, taking upward as positive, T − m g = m v² / L. '
        'm v² / L = m g. T = 2 m g = 2 × 0.100 × 9.8 = 1.96 N.',
  ),
  'a9200667-eb7b-4eb0-8b3b-ecf7e4adfc0b': ProblemTranslation(
    theme: 'Pressure in a fluid',
    title: 'Pressure difference between two floors',
    statement:
        'The height difference between the first and second floors '
        'is 5.0 m. Find the difference in air pressure, in hPa.\n'
        '※Take the density of air to be 1.0 kg/m³ and g = 9.8 m/s². '
        'Treat the density as constant over this height.',
    hint: 'The height difference is small, so treat the air between the floors as a fluid of constant density.',
    approach:
        'In a fluid of constant density, the pressure difference over Δh is ρ g Δh.',
    firstStep: 'Δp = 1.0 × 9.8 × 5.0.',
    explanation:
        'The pressure difference in a fluid of constant density is Δp = ρ g Δh. '
        'Δp = 1.0 × 9.8 × 5.0 = 49 Pa. '
        '1 hPa = 100 Pa, so 49 Pa = 0.49 hPa.',
  ),
  '5c3c97ec-01f2-4eb6-a717-6099182aa327': ProblemTranslation(
    theme: 'Air pressure versus height',
    title: 'Air pressure on Mount Fuji',
    statement:
        'As shown, at altitude 0 m the pressure is 1013 hPa and the temperature '
        'is 15°C. Temperature falls at a constant rate with height, and air is '
        'an ideal gas. Find the pressure at 3000 m, in hPa.\n'
        '※Take 0°C as 273 K, the molar mass of air as 29 g/mol, '
        'g = 9.8 m/s², and R = 8.31 J/(mol·K). '
        'You may take (T / T₀)^(M g / (k R)) = 0.80.',
    hint:
        'Higher up, the temperature is lower, so the weight of a layer of air changes. '
        'Multiply the surface pressure by a power of the temperature ratio.',
    approach:
        'When temperature falls at a constant rate, '
        'p = p₀ (T / T₀)^(M g / (k R)).',
    firstStep: 'p = 1013 × 0.80.',
    explanation:
        'When temperature falls with height at a constant rate k, '
        'p = p₀ (T / T₀)^(M g / (k R)). '
        'From the note, (T / T₀)^(M g / (k R)) = 0.80. '
        'p = 1013 × 0.80 = 810.4 hPa.',
  ),
  '6ede92dc-5a1f-45dd-8bd5-aad99c9ea5da': ProblemTranslation(
    theme: 'Definition of pressure [Pa]',
    title: 'Force that pulls a syringe',
    statement:
        'As shown, the piston of a syringe of radius 1.0 cm is pulled until the '
        'inside is nearly a vacuum. Find the magnitude of the force with which '
        'the outside air pressure pushes the piston, in N.\n'
        '※Take the pressure to be 1.0×10⁵ Pa and π = 3.14.',
    hint:
        'If almost no air pushes from inside, only the force of the outside pressure on the face remains.',
    approach: 'From the definition p = F / S, the force is F = p S.',
    firstStep: 'F = 1.0×10⁵ × 3.14 × (1.0×10⁻²)².',
    explanation:
        'The force is F = p S. The radius is 1.0×10⁻² m. '
        'S = π r² = 3.14 × 1.0×10⁻⁴ = 3.14×10⁻⁴ m². '
        'F = 1.0×10⁵ × 3.14×10⁻⁴ = 31.4 N.',
  ),
  'b2264701-1475-4352-a05d-e5271f77caff': ProblemTranslation(
    theme: 'Pressure under an open water surface',
    title: 'Pressure at a depth of 30 cm',
    statement:
        'As shown, find the pressure 30 cm below a water surface open to the '
        'atmosphere, in hPa.\n'
        '※Take the surface pressure to be 1013 hPa, the density of water to be '
        '1000 kg/m³, and g = 9.8 m/s².',
    hint:
        'Below an open surface, the pressure of the atmosphere is added to the pressure from the weight of the water.',
    approach: 'The pressure under an open surface is p = p₀ + ρ g h.',
    firstStep: 'p = 1013 + 1000 × 9.8 × 0.30 / 100.',
    explanation:
        'The pressure under an open surface is p = p₀ + ρ g h. '
        'ρ g h = 1000 × 9.8 × 0.30 = 2940 Pa = 29.4 hPa. '
        'p = 1013 + 29.4 = 1042.4 hPa.',
  ),
  'cc8cd992-df30-4283-b758-2c7bba07336a': ProblemTranslation(
    theme: 'Pressure at the top of a closed water column',
    title: 'Pressure at the top of an inverted container',
    statement:
        'As shown, the mouth of a water-filled inverted container is 3.0 cm '
        'below an open water surface, and the water inside stands 28 cm above '
        'the mouth. Find the pressure at the closed top, in hPa.\n'
        '※Take the open-surface pressure to be 1013 hPa, the density of water '
        'to be 1000 kg/m³, and g = 9.8 m/s².',
    hint:
        'The mouth is in the open water. The closed top is higher than that mouth.',
    approach: 'In the same water, pressure falls by ρ g h as the height rises.',
    firstStep: 'p = 1013 − 1000 × 9.8 × 0.25 / 100.',
    explanation:
        'The closed top is 28 − 3.0 = 25 cm above the open surface. '
        'The pressure is p = p₀ − ρ g h. '
        'ρ g h = 1000 × 9.8 × 0.25 = 2450 Pa = 24.5 hPa. '
        'p = 1013 − 24.5 = 988.5 hPa.',
  ),
  'ebf0977f-94f9-4e30-8415-95fe3b05b3c2': ProblemTranslation(
    theme: 'Pressure in salt water',
    title: 'Pressure 50 cm down in salt water',
    statement:
        'As shown, find the pressure 50 cm below a salt-water surface open to '
        'the atmosphere, in hPa.\n'
        '※Take the surface pressure to be 1013 hPa, the density of the salt '
        'water to be 1.20 g/cm³, and g = 9.8 m/s².',
    hint:
        'Salt water is denser than fresh water. The pressure at a depth uses that density.',
    approach: 'The pressure under an open liquid surface is p = p₀ + ρ g h.',
    firstStep: 'p = 1013 + 1200 × 9.8 × 0.50 / 100.',
    explanation:
        'The pressure under an open surface is p = p₀ + ρ g h. '
        'The density is 1.20 g/cm³ = 1200 kg/m³. '
        'ρ g h = 1200 × 9.8 × 0.50 = 5880 Pa = 58.8 hPa. '
        'p = 1013 + 58.8 = 1071.8 hPa.',
  ),
  '185ad466-4a2a-474a-97d8-e2635c9da116': ProblemTranslation(
    theme: 'Mass lifted by helium',
    title: 'Mass lifted by a helium bag',
    statement:
        'As shown, a bag of mass 1.0 g is filled with 2.493 L of helium at 27°C '
        'and 1.0×10⁵ Pa. Besides its own mass, how many grams can this bag lift?\n'
        '※Treat air and helium as ideal gases, with molar masses 29 g/mol and '
        '4.0 g/mol, and R = 8.31 J/(mol·K). '
        'The volume of the bag equals the volume of the gas inside.',
    hint:
        'Subtract the weight of the helium and the bag from the weight of the air the bag displaces. What remains can be lifted.',
    approach:
        'Buoyancy is the weight of the displaced air. The amount of substance comes from the ideal-gas law.',
    firstStep: '1.0×10⁵ × 2.493×10⁻³ = n × 8.31 × 300.',
    explanation:
        'The ideal-gas law is p V = n R T. '
        'T = 27 + 273 = 300 K. '
        'n = 1.0×10⁵ × 2.493×10⁻³ / (8.31 × 300). '
        '8.31 × 300 = 2493. p V = 249.3. '
        'n = 249.3 / 2493 = 0.100 mol. '
        'The mass of air is 0.100 × 29 = 2.9 g. '
        'The mass of helium is 0.100 × 4.0 = 0.40 g. '
        'The mass that can be lifted is 2.9 − 0.40 − 1.0 = 1.5 g.',
  ),
  '6302cba4-20d1-418d-bcd4-8bc9139112ef': ProblemTranslation(
    theme: 'Electrical resistance of a conductor',
    title: 'Resistance of 0.785 m of nichrome wire',
    statement:
        'Find the resistance of a nichrome wire of diameter 0.50 mm '
        'and length 0.785 m, in Ω.\n'
        '※Take the resistivity to be 1.0×10⁻⁶ Ω·m and π = 3.14.',
    hint: 'For the same material, a thinner and longer wire has a larger resistance. The cross section is a circle.',
    approach: 'The resistance of a conductor is R = ρ L / S.',
    firstStep: 'R = 1.0×10⁻⁶ × 0.785 / (3.14 × (0.25×10⁻³)²).',
    explanation:
        'The resistance of a conductor is R = ρ L / S. '
        'The radius is 0.25×10⁻³ m. '
        'S = 3.14 × (0.25×10⁻³)² = 3.14 × 6.25×10⁻⁸ = 1.9625×10⁻⁷ m². '
        'ρ L = 1.0×10⁻⁶ × 0.785 = 7.85×10⁻⁷. '
        'R = 7.85×10⁻⁷ / 1.9625×10⁻⁷ = 4.0 Ω.',
  ),
  '3ea78b46-ce98-4631-8e40-d6adaffd4c92': ProblemTranslation(
    theme: 'Temperature dependence of resistivity',
    title: 'Resistance of a copper wire at 50°C',
    statement:
        'As shown, find the resistance at 50°C of a copper wire of cross '
        'section 1.0×10⁻⁸ m² and length 10 m, in Ω.\n'
        '※Take the resistivity at 0°C to be 1.0×10⁻⁸ Ω·m and the temperature '
        'coefficient to be 0.0040 /°C.',
    hint:
        'A metal’s resistivity rises when it is warmed. Find the resistivity at 50°C, then the resistance from the length and cross section.',
    approach: 'Resistivity is ρ = ρ₀ (1 + α t), and resistance is R = ρ L / S.',
    firstStep: 'ρ = 1.0×10⁻⁸ × (1 + 0.0040 × 50).',
    explanation:
        'Resistivity is ρ = ρ₀ (1 + α t). '
        'ρ = 1.0×10⁻⁸ × (1 + 0.20) = 1.0×10⁻⁸ × 1.20 = 1.20×10⁻⁸ Ω·m. '
        'R = 1.20×10⁻⁸ × 10 / 1.0×10⁻⁸ = 1.20×10⁻⁷ / 1.0×10⁻⁸ = 12.0 Ω.',
  ),
  'fec7eb08-b848-4ce9-86f1-bfcf489ed905': ProblemTranslation(
    theme: 'Magnetic field on the axis of a circular current',
    title: 'Magnetic field at the center of a circular coil',
    statement:
        'As shown, a circular coil of radius 6.28 cm has 100 turns and carries '
        '1.0 A. Find the magnitude of the magnetic flux density at the center, '
        'in mT.\n'
        '※Take μ₀ = 4π×10⁻⁷ H/m and π = 3.14.',
    hint:
        'At the center of a circular wire, the field from every part points the same way. The turns multiply it.',
    approach:
        'The flux density at the center of a circular current is B = μ₀ N I / (2 r).',
    firstStep: 'B = (4 × 3.14 × 10⁻⁷ × 100 × 1.0) / (2 × 0.0628).',
    explanation:
        'The flux density at the center of a circular current is B = μ₀ N I / (2 r). '
        'μ₀ = 4 × 3.14 × 10⁻⁷ = 1.256×10⁻⁶ H/m. '
        'The numerator is 1.256×10⁻⁶ × 100 × 1.0 = 1.256×10⁻⁴. '
        'The denominator is 2 × 0.0628 = 0.1256. '
        'B = 1.256×10⁻⁴ / 0.1256 = 1.0×10⁻³ T = 1.0 mT.',
  ),
  '4f720ff4-0c1b-47ff-baa6-70195e82f7bb': ProblemTranslation(
    theme: 'Solution of the RC-circuit equation',
    title: 'Time when the resistor voltage is halved',
    statement:
        'As shown, a 5000 μF capacitor charged to 3.0 V is discharged through '
        'a 2000 Ω resistor. Find the time when the voltage across the resistor '
        'is 1.5 V, in s.\n'
        '※Take ln 2 = 0.693. Discharge starts at t = 0.',
    hint:
        'During discharge, the resistor voltage falls from its initial value with a time set by R and C. One half is a special fraction.',
    approach: 'The solution for an RC discharge is V = V₀ e^(−t / RC).',
    firstStep: '1.5 = 3.0 × e^(−t / (2000 × 5000×10⁻⁶)).',
    explanation:
        'The voltage of an RC discharge is V = V₀ e^(−t / RC). '
        'When V = V₀ / 2, t = RC ln 2. '
        'C = 5000×10⁻⁶ = 5.0×10⁻³ F. RC = 2000 × 5.0×10⁻³ = 10 s. '
        't = 10 × 0.693 = 6.93 s.',
  ),
  '8b3abed0-2226-49ed-9b04-7c3d63852077': ProblemTranslation(
    theme: 'Self-inductance of a solenoid',
    title: 'Self-inductance of a solenoid',
    statement:
        'As shown, wire is wound 100 times on a tube of length 0.314 m. '
        'The tube radius is 1.0 cm. Find the self-inductance in μH.\n'
        '※Take μ₀ = 1.256×10⁻⁶ H/m and π = 3.14.',
    hint:
        'The field inside a long coil is set by the turns per length and the current. Inductance is the factor by which that flux is proportional to the current.',
    approach: 'The self-inductance of a solenoid is L = μ₀ n² S ℓ.',
    firstStep:
        'L = 1.256×10⁻⁶ × (100 / 0.314)² × 3.14 × (1.0×10⁻²)² × 0.314.',
    explanation:
        'The self-inductance of a solenoid is L = μ₀ N² S / ℓ. '
        'S = 3.14 × (1.0×10⁻²)² = 3.14 × 1.0×10⁻⁴ = 3.14×10⁻⁴ m². '
        'N² S / ℓ = 10000 × 3.14×10⁻⁴ / 0.314 = 3.14 / 0.314 = 10. '
        'L = 1.256×10⁻⁶ × 10 = 1.256×10⁻⁵ H = 12.56 μH.',
  ),
  'cbde552e-65b9-4102-a827-92de2ea4d513': ProblemTranslation(
    theme: 'Force on a current in a magnetic field',
    title: 'Force on an aluminum bar',
    statement:
        'As shown, an aluminum bar of length 2.0 cm is perpendicular to a '
        'uniform field of 0.20 T, and a current of 1.0 A flows perpendicular '
        'to both the field and the bar. Find the magnitude of the force on the '
        'bar, in N.',
    hint:
        'When the current and the field are perpendicular, the force is perpendicular to both and is the product of current, length, and flux density.',
    approach: 'The magnitude of the force on a current in a magnetic field is F = I B L.',
    firstStep: 'F = 1.0 × 0.20 × 0.020.',
    explanation:
        'When the current and the field are perpendicular, the magnitude of the force is F = I B L. '
        'L = 2.0 cm = 0.020 m. F = 1.0 × 0.20 × 0.020 = 4.0×10^-3 N.',
  ),
  'd9ed9c59-ef5b-4880-b07d-320542a4c373': ProblemTranslation(
    theme: 'Atomic radius of a metal crystal',
    title: 'Atomic radius of aluminum',
    statement:
        'As shown, a cube of aluminum with edge 3.0 cm has mass 78.0 g. '
        'Treat each atom as a sphere that occupies a fraction 0.74 of the volume. '
        'Find the atomic radius in pm.\n'
        '※Take the atomic weight to be 27, Avogadro’s number to be '
        '6.02×10²³ /mol, and π = 3.14. You may take 1.40³ = 2.744.',
    hint:
        'Dividing the volume of the cube by the number of atoms gives the volume per atom. A fraction 0.74 of that is the sphere.',
    approach:
        'The atomic radius comes from the sphere volume of one atom, (4/3) π r³.',
    firstStep:
        '(4/3) × 3.14 × r³ = 0.74 × (3.0×10⁻²)³ / ((78.0 / 27) × 6.02×10²³).',
    explanation:
        'The sphere volume of one atom is (4/3) π r³, which is 0.74 times the volume per atom. '
        'The cube volume is (3.0×10⁻²)³ = 2.70×10⁻⁵ m³. '
        'The amount of substance is 78.0 / 27 = 2.888... mol. '
        'The number of atoms is 2.888... × 6.02×10²³ = 1.739×10²⁴. '
        'The volume per atom is 2.70×10⁻⁵ / 1.739×10²⁴ = 1.553×10⁻²⁹ m³. '
        'The sphere volume is 0.74 × 1.553×10⁻²⁹ = 1.149×10⁻²⁹ m³. '
        '(4/3) π = 4.187. r³ = 1.149×10⁻²⁹ / 4.187 = 2.744×10⁻³⁰. '
        'From the note, r = 1.40×10⁻¹⁰ m = 140 pm.',
  ),
};
