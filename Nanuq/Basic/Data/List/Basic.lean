module

public import Mathlib.Data.List.Infix

/-!
# Members of a list in the order they come

Two or three distinct members of a list, given as values of a function, come in some order: the
list splits around them. Mathlib has the version for one member (`List.append_of_mem`).
-/

@[expose] public section

namespace List

variable {α β : Type*}

/-- Two members of a list, in the order they come. -/
theorem exists_sort_two {g : β → α} {L : List α} {u v : β} (hu : g u ∈ L) (hv : g v ∈ L) (huv : g u ≠ g v) :
    ∃ a b, (a = u ∧ b = v ∨ a = v ∧ b = u) ∧ ∃ A B D, L = A ++ g a :: (B ++ g b :: D) := by
  induction L with
  | nil => simp at hu
  | cons z L ih =>
    by_cases hzu : z = g u
    · subst hzu
      have hv' : g v ∈ L := (List.mem_cons.1 hv).resolve_left (Ne.symm huv)
      obtain ⟨B, D, rfl⟩ := List.append_of_mem hv'
      exact ⟨u, v, Or.inl ⟨rfl, rfl⟩, [], B, D, rfl⟩
    by_cases hzv : z = g v
    · subst hzv
      have hu' : g u ∈ L := (List.mem_cons.1 hu).resolve_left huv
      obtain ⟨B, D, rfl⟩ := List.append_of_mem hu'
      exact ⟨v, u, Or.inr ⟨rfl, rfl⟩, [], B, D, rfl⟩
    obtain ⟨a, b, hab, A, B, D, rfl⟩ := ih ((List.mem_cons.1 hu).resolve_left (Ne.symm hzu)) ((List.mem_cons.1 hv).resolve_left (Ne.symm hzv))
    exact ⟨a, b, hab, z :: A, B, D, rfl⟩

/-- Three members of a list, in the order they come. -/
theorem exists_sort_three {g : β → α} {L : List α} {u v w : β} (hu : g u ∈ L) (hv : g v ∈ L) (hw : g w ∈ L)
    (huv : g u ≠ g v) (huw : g u ≠ g w) (hvw : g v ≠ g w) :
    ∃ a b c, (∀ t, t = a ∨ t = b ∨ t = c ↔ t = u ∨ t = v ∨ t = w) ∧ ∃ A B D F, L = A ++ g a :: (B ++ g b :: (D ++ g c :: F)) := by
  induction L with
  | nil => simp at hu
  | cons z L ih =>
    by_cases hzu : z = g u
    · subst hzu
      obtain ⟨a, b, hab, A, B, D, rfl⟩ := exists_sort_two (g := g) ((List.mem_cons.1 hv).resolve_left (Ne.symm huv))
        ((List.mem_cons.1 hw).resolve_left (Ne.symm huw)) hvw
      refine ⟨u, a, b, fun t => ?_, [], A, B, D, rfl⟩
      rcases hab with ⟨rfl, rfl⟩ | ⟨rfl, rfl⟩ <;> tauto
    by_cases hzv : z = g v
    · subst hzv
      obtain ⟨a, b, hab, A, B, D, rfl⟩ := exists_sort_two (g := g) ((List.mem_cons.1 hu).resolve_left huv)
        ((List.mem_cons.1 hw).resolve_left (Ne.symm hvw)) huw
      refine ⟨v, a, b, fun t => ?_, [], A, B, D, rfl⟩
      rcases hab with ⟨rfl, rfl⟩ | ⟨rfl, rfl⟩ <;> tauto
    by_cases hzw : z = g w
    · subst hzw
      obtain ⟨a, b, hab, A, B, D, rfl⟩ := exists_sort_two (g := g) ((List.mem_cons.1 hu).resolve_left huw)
        ((List.mem_cons.1 hv).resolve_left hvw) huv
      refine ⟨w, a, b, fun t => ?_, [], A, B, D, rfl⟩
      rcases hab with ⟨rfl, rfl⟩ | ⟨rfl, rfl⟩ <;> tauto
    obtain ⟨a, b, c, habc, A, B, D, F, rfl⟩ := ih ((List.mem_cons.1 hu).resolve_left (Ne.symm hzu))
      ((List.mem_cons.1 hv).resolve_left (Ne.symm hzv)) ((List.mem_cons.1 hw).resolve_left (Ne.symm hzw))
    exact ⟨a, b, c, habc, z :: A, B, D, F, rfl⟩

/-- A pair in order is a sublist. -/
theorem pair_sublist (X : List α) (u : α) (Y : List α) (w : α) (Z : List α) : List.Sublist [u, w] (X ++ u :: (Y ++ w :: Z)) := by
  induction X with
  | nil =>
    refine List.Sublist.cons_cons u ?_
    exact List.singleton_sublist.2 (by simp)
  | cons a X ih => exact List.Sublist.cons a ih

end List
