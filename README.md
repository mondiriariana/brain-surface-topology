# 🧠 Topological Complexity of Cortical Surface Meshes: A Visual Exploration in MATLAB

## 📌 Introduction

This project explores the topological and geometric complexity of a human cortical surface mesh using MATLAB.

We began with a 3D `.obj` mesh generated from an MRI scan of a human brain. Using MATLAB, we:

- Loaded and visualized the brain mesh
- Computed key topological values:
  - **Euler characteristic** (χ = V - E + F)
  - **Genus** (g = 1 - χ / 2)
- Applied **Gaussian smoothing** and **sinusoidal noise** to deform the mesh
- Recomputed topological and geometric properties after deformation
- Rendered side-by-side 3D views of the original and noisy meshes
- Used surface color maps to highlight curvature changes

This visual exploration shows how brain shape can be modified without altering its underlying structure.

---

## 📊 Summary of Mesh Comparison Results

Despite surface deformation, **topological properties remained unchanged** between the original and noisy meshes:

| Metric | Value (Original & Noisy) | Interpretation                     |
|--------|---------------------------|-------------------------------------|
| `V`    | Same                      | Number of 3D points (vertices)      |
| `E`    | Same                      | Number of unique edges              |
| `F`    | Same                      | Number of triangular faces          |
| `χ`    | Same                      | Euler characteristic                |
| `g`    | Same                      | Genus (holes/handles)               |

However, **geometric properties changed**:

| Metric | Observation | Interpretation                       |
|--------|-------------|---------------------------------------|
| `Area` | Different   | Surface area changed due to noise     |
| `Vol`  | Different   | Enclosed volume altered               |

> These results demonstrate that **topology (connectivity)** remains stable under deformation, while **geometry (shape/size)** is affected.

---

## 📘 Glossary of Symbols

| Symbol | Meaning                 | Description                          |
|--------|--------------------------|--------------------------------------|
| `V`    | Number of vertices       | Total number of mesh points          |
| `E`    | Number of edges          | Total number of unique mesh edges    |
| `F`    | Number of faces          | Total number of triangular faces     |
| `Area` | Surface area             | Total mesh surface area              |
| `Vol`  | Enclosed volume          | Volume enclosed by the mesh          |
| `χ`    | Euler characteristic     | Topological invariant (`V - E + F`)  |
| `g`    | Genus                    | Number of holes or handles (`1 - χ/2`) |

---
