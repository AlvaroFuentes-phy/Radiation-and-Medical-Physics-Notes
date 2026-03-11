# Radiation and Medical Physics - MATLAB Suite

This directory includes several complementary programs developed for the **Radiation and Medical Physics** course.
## 1. Orbital_Visualizer.m
This program calculates and draws atomic orbitals by solving the angular and radial components of the hydrogenic wave function. Choose the principal, azimuthal, and magnetic quantum numbers to visualize the resulting 3D geometry.

This repository contains a comprehensive **MATLAB implementation** of the Liquid Drop Model, focusing on the **Semi-Empirical Mass Formula (SEMF)**. This project is part of a study on Ionizing Radiation and the fundamentals of Atomic and Nuclear Physics.

## 2. Physical Theoretical Framework
The simulation is based on the **Weizsäcker-Bohr formula**, which treats the atomic nucleus as a drop of incompressible nuclear fluid. The binding energy ($B$) is determined by five key physical terms:

1. **Volume Term:** Cohesive force proportional to the number of nucleons ($A$).
2. **Surface Term:** Negative correction for nucleons at the nuclear surface.
3. **Coulomb Term:** Electrostatic repulsion between protons ($Z$).
4. **Asymmetry Term:** Energy penalty for $N \neq Z$ imbalances.
5. **Pairing Term:** Quantum effect based on even/odd nucleon numbers.

## 3. Key Features
The script provides a deep numerical and visual analysis of nuclear stability:
* **Stability Curve:** Visualization of Binding Energy per Nucleon ($BE/A$) highlighting the **Fe-56** peak.
* **Valley of Stability:** A 2D heatmap (Nuclide Chart) showing the energy landscape and **Magic Numbers** ($2, 8, 20, 28, 50$).
* **Reaction Analysis:** Quantitative calculation of energy released during **U-235 Fission** and **D-T Fusion**.

<img width="1500" height="990" alt="plot_estabilidad" src="https://github.com/user-attachments/assets/681e38e4-2a96-4dfd-b76f-8d73b51596e8" />

### 3. IMRT Dose Optimization Simulator (`IMRT_Planner.m`)

A high-level simulation of **Intensity Modulated Radiation Therapy (IMRT)** focusing on bone marrow treatments. This tool demonstrates the physics of "Inverse Planning" and computational dosimetry through an objective-based optimization approach.

* **Dose Influence Matrix ($A_{ij}$):** Computes the geometric and physical deposition of energy from multiple beamlets using ray-casting and attenuation approximations. It maps the contribution of each individual beamlet to every voxel in the patient's anatomy.
* **Inverse Planning Optimization:** Solves a non-negative least squares problem to find the optimal beam weights ($w$) that satisfy clinical constraints:
    $$\min_{w \ge 0} \|Aw - D_{target}\|^2$$
* **Clinical Dosimetry Tools:**
    * **Isodose Maps:** 2D spatial distribution of absorbed dose in Gray (Gy) overlaid on the anatomical phantom.
    * **DVH (Dose-Volume Histogram):** Quantitative evaluation of target coverage (Bone Marrow) vs. Organ at Risk (OAR) sparing, essential for clinical plan approval.



* **Configurable Parameters:** Adjustable beam angles (gantry positions), beamlet resolution, and importance weighting factors to balance target prescription versus healthy tissue protection.
