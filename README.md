# 🕵️ Prolog Murder Mystery Expert System

## 📌 Overview
This project implements a **knowledge-based expert system** using **Prolog** to solve a murder mystery inside an IT company. A project manager is found murdered, and multiple employees become suspects. Using logical reasoning over facts, rules, and relationships, the system deduces the most likely killer or killer group.

Instead of hard-coding conclusions, the system **infers results logically**, demonstrating how **symbolic AI** can be used for complex decision-making problems.

---

## 🧠 AI Concept Used
This project belongs to the domain of:

- **Knowledge Representation and Reasoning (KRR)**
- **Expert Systems**
- **Logic Programming**
- **Symbolic Artificial Intelligence**

No machine learning or statistical models are used. All conclusions are derived through **logical inference** over explicitly defined knowledge.

---

## 🏢 Case Scenario
A project manager working in an IT company is murdered during office hours. The investigation involves:
- Employees from different departments
- Crime time window and erased CCTV footage
- Fingerprint evidence found in restricted locations
- Conflicting testimonies
- Motives such as financial fraud, blackmail, and personal conflict
- Cover-up relationships between employees

All these details are encoded as **Prolog facts**, allowing the system to reason over them.

---

## 📚 Knowledge Base
The Prolog knowledge base includes high-level information such as:
- Suspects and victim
- Employee roles and departments
- Crime location and time window
- Exit logs
- Motive evidence
- Fingerprint evidence across different rooms
- Testimonies and contradictions
- Cover-up relationships between suspects

---

## ⚙️ Logical Rules and Reasoning
The system applies layered reasoning using Prolog rules:
- Identification of **strong suspects** based on motive and presence
- Detection of **contradictory statements**
- Validation of **unauthorized fingerprint evidence**
- Elimination of suspects through logical filtering
- Identification of **individual killers**, **killer pairs**, or **criminal groups**
- Recursive reasoning to detect **chains of collaboration or deception**

The final conclusion is reached entirely through **logical deduction**.

---

## 🔍 Sample Queries
```prolog
?- strong_suspect(X).
?- possible_killer(X).
?- possible_killer_pair(X, Y).
?- killer(X).
?- killer_pair(X, Y).
?- killer_group_chain(X, Y).
?- killer_pair_motives(X, Motive).
?- killer_pair_evidence(X, Evidence).
?- killer_pair_coverup(X, Coverup).
