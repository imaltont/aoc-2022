#!/usr/local/bin/apl -s --OFF
∇Z←charPri ch ;charVal
  charVal←⎕UCS ch
  small ← (ι26) + 96
  small_cont ← (charVal ∊ small) × ¯96
  big ← (ι26) + 64
  big_cont ← (charVal ∊ big) × ¯38
  Z←charVal + small_cont + big_cont
∇

∇Z←calcLine line
  split_line ← ((⍴line) ÷ 2 , 2)⍴line
  top ← ∪split_line[1;]
  bottom ← ∪split_line[2;]
  dups ← top ∊ bottom
  weights ← dups × charPri top
  Z←+/weights
∇
content←calcLine⎕FIO[49] 'resources/input'

part2content←⎕FIO[49] 'resources/input'
part2content←(((⍴part2content) ÷ 3), 3)⍴part2content

∇Z←calcTrippleLine line
  top ← ∪⊃line[1]
  middle ← ∪⊃line[2]
  bottom ← ∪⊃line[3]
  dups1 ← top ∊ middle 
  dups2 ← top ∊ bottom
  dups ← dups1 × dups2
  weights ← dups × charPri top
  Z←+/weights
∇
'Part 1:'
+/content ⍝⍝ Part 1
'Part 2:'
+/(calcTrippleLine⍤1⊢part2content) ⍝⍝ Part 2
