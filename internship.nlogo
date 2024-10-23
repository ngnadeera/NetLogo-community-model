; NetLogo Code to Simulate the Internship Scenario Over 10 Years

; Declare agent breeds
breed [students student]
breed [companies company]
breed [universities university]
breed [policymakers policymaker]

; Define global variables
globals [
  economic-condition    ; Represents current economic state (0-100)
  policy-active         ; Indicates if a policy is active
  policy-strength       ; Effectiveness of the current policy
  time-period           ; Current time period (e.g., year)
  
  max-economic-condition   ; Maximum economic condition value
  min-economic-condition   ; Minimum economic condition value
]

; Students' properties
students-own [
  grade               ; Grade category (A1, A2, B1, etc.)
  university-type     ; 'government', 'private', or 'other'
  has-internship      ; True if the student secured an internship
  skill-alignment     ; Alignment of student's skills with industry needs (0-100)
]

; Companies' properties
companies-own [
  company-size        ; 'large', 'medium', 'small'
  capacity            ; Internship capacity
  internships-offered ; Number of internships currently offered
  required-skill-level ; Minimum skill alignment required
]

; Universities' properties
universities-own [
  university-type     ; 'government' or 'private'
  curriculum-alignment ; Curriculum alignment with industry needs (0-100)
]

; Policymakers' properties
policymakers-own [
  ; Attributes can be added here if needed
]

; Setup procedure
to setup
  clear-all
  setup-patches
  setup-universities
  setup-companies
  setup-students
  setup-policymaker
  
  ; Initialize global variables
  set economic-condition 80      ; Start with a relatively stable economy
  set policy-active false
  set policy-strength 0
  set time-period 1
  
  ; Initialize constants
  set max-economic-condition 100
  set min-economic-condition 0
  
  reset-ticks
end

; Setup patches to define areas
to setup-patches
  ; Ensure the world dimensions are sufficient
  ; Adjust the world settings in the Interface tab: min-pycor -20, max-pycor 20
  ask patches [
    ifelse pycor < -5 [
      set pcolor gray  ; Student Area
    ] [
      ifelse pycor > 5 [
        set pcolor sky  ; IT Company Area
      ] [
        set pcolor white ; Interaction Zone
      ]
    ]
  ]
end

; Create universities on the left side
to setup-universities
  ; Create custom shapes if needed using the Shape Editor or use built-in shapes
  
  ; Create government university
  create-universities 1 [
    set university-type "government"
    set shape "university"    ; Use built-in shape "house"
    set color green
    set size 3
    setxy min-pxcor + 2 0
    set curriculum-alignment 60
  ]
  
  ; Create private university
  create-universities 1 [
    set university-type "private"
    set shape "university"    ; Use built-in shape "house"
    set color brown
    set size 3
    setxy min-pxcor + 2 -5
    set curriculum-alignment 50
  ]
end

; Create companies on the top
to setup-companies
  ; Create custom shapes if needed using the Shape Editor or use built-in shapes
  
  ; Large-scale company
  create-companies 1 [
    set company-size "large"
    set shape "office"    ; Use built-in shape "office"
    set color blue
    set size 4
    setxy 0 max-pycor - 2
  ]
  
  ; Medium-scale companies
  create-companies 2 [
    set company-size "medium"
    set shape "office"
    set color blue
    set size 3
    setxy random-xcor (max-pycor - 4)
  ]
  
  ; Small-scale companies
  create-companies 3 [
    set company-size "small"
    set shape "office"
    set color blue
    set size 2
    setxy random-xcor (max-pycor - 6)
  ]
end

; Create students at the bottom
to setup-students
  ; Use built-in shape "person"
  
  ; Create Grade A1 students from government universities
  create-students 20 [
    set grade "A1"
    set university-type "government"
    set shape "person"
    set color green
    set size 1.5
    set has-internship false
    setxy random-xcor (min-pycor + 1)
    set skill-alignment 70
  ]
  
  ; Create Grade A2 students from private universities
  create-students 30 [
    set grade "A2"
    set university-type "private"
    set shape "person"
    set color lime
    set size 1.5
    set has-internship false
    setxy random-xcor (min-pycor + 2)
    set skill-alignment 65
  ]
  
  ; Create Grade B students
  create-students 50 [
    set grade "B"
    set university-type one-of ["government" "private"]
    set shape "person"
    set color yellow
    set size 1.5
    set has-internship false
    setxy random-xcor (min-pycor + 3)
    set skill-alignment 55
  ]
  
  ; Create Grade C students
  create-students 30 [
    set grade "C"
    set university-type one-of ["government" "private"]
    set shape "person"
    set color red
    set size 1.5
    set has-internship false
    setxy random-xcor (min-pycor + 4)
    set skill-alignment 45
  ]
end

; Create the government policymaker on the right side
to setup-policymaker
  create-policymakers 1 [
    set shape "policy"    ; Use built-in shape "building tall"
    set color gray
    set size 4
    setxy (max-pxcor - 2) 0
  ]
end

; Main simulation procedure
to go
  if ticks > 120 [ stop ]  ; Simulate for 10 years (120 months)
  
  ; Update time period
  if ticks mod 12 = 0 [
    set time-period time-period + 1
  ]
  
  update-economic-condition
  update-policies
  update-company-capacities
  update-company-requirements
  update-universities
  update-students-skills
  introduce-non-it-graduates
  
  move-students
  check-internships
  
  ; Update plots
  do-plots
  
  tick
end

; Update economic conditions
to update-economic-condition
  set economic-condition 50 + 30 * sin (ticks * 0.05)
  
  ; Ensure economic-condition stays within bounds
  if economic-condition > max-economic-condition [
    set economic-condition max-economic-condition
  ]
  if economic-condition < min-economic-condition [
    set economic-condition min-economic-condition
  ]
end

; Update policies
to update-policies
  ; Check if intervention is needed
  if (economic-condition < 40 and not policy-active) [
    ; Activate policy intervention
    set policy-active true
    set policy-strength 20  ; Increase companies' capacity by 20%
    ; Visual feedback
    ask policymakers [
      set color yellow
    ]
  ]
  
  ; Policy lasts for 2 years (24 ticks)
  if (policy-active and ticks mod 24 = 0) [
    set policy-active false
    set policy-strength 0
    ; Reset visual feedback
    ask policymakers [
      set color gray
    ]
  ]
end

; Update companies' capacities based on economic conditions and policies
to update-company-capacities
  ask companies [
    ; Base capacity depends on company size
    let base-capacity 0
    if company-size = "large" [ set base-capacity 20 ]
    if company-size = "medium" [ set base-capacity 10 ]
    if company-size = "small" [ set base-capacity 5 ]
    
    ; Adjust capacity based on economic condition
    let economic-factor economic-condition / 100
    set capacity base-capacity * economic-factor
    
    ; Apply policy incentives if active
    if policy-active [
      set capacity capacity * (1 + policy-strength / 100)
    ]
    
    ; Round capacity to nearest integer
    set capacity round capacity
    
    ; Ensure capacity is at least 1
    if capacity < 1 [
      set capacity 1
    ]
    
    ; Reset internships offered for the new period
    set internships-offered 0
    
    ; Update color based on capacity (visualization)
    ifelse capacity > base-capacity [ 
      set color green 
    ] [
      ifelse capacity < base-capacity [
        set color red
      ] [
        set color blue
      ]
    ]
  ]
end

; Update companies' required skill levels
to update-company-requirements
  ask companies [
    ; Required skill level depends on company size
    if company-size = "large" [ set required-skill-level 70 ]
    if company-size = "medium" [ set required-skill-level 60 ]
    if company-size = "small" [ set required-skill-level 50 ]
  ]
end

; Universities improve curricula over time
to update-universities
  ask universities [
    ; Improve curriculum alignment over time
    set curriculum-alignment curriculum-alignment + 0.5
    if curriculum-alignment > 100 [
      set curriculum-alignment 100  ; Max 100%
    ]
  ]
end

; Students' skill alignment updates
to update-students-skills
  ask students [
    if not has-internship [
      ; Skill alignment influenced by university's curriculum
      let my-university one-of universities with [ university-type = [university-type] of myself ]
      if my-university != nobody [
        set skill-alignment [curriculum-alignment] of my-university
      ]
    ]
  ]
end

; Introduce non-IT graduates entering the IT sector
to introduce-non-it-graduates
  if ticks = 24 [  ; Introduce after 2 years
    create-students 20 [
      set grade "Non-IT"
      set university-type "other"
      set shape "person"
      set color gray
      set size 1.5
      set has-internship false
      setxy random-xcor (min-pycor + 5)
      set skill-alignment 30  ; Lower skill alignment
    ]
  ]
end

; Move students towards companies
to move-students
  ask students [
    if not has-internship [
      face one-of companies
      fd 0.5
    ]
  ]
end

; Students apply for internships when near a company
to check-internships
  ask students [
    if not has-internship [
      let nearby-company min-one-of companies [ distance myself ]
      if distance nearby-company < 1 [
        ; Company evaluates the student based on skill alignment
        if [internships-offered] of nearby-company < [capacity] of nearby-company [
          if skill-alignment >= [required-skill-level] of nearby-company [
            ; Student secures an internship
            set has-internship true
            set color blue  ; Change color to indicate success
            
            ; Update company's internships offered
            ask nearby-company [
              set internships-offered internships-offered + 1
            ]
            
            ; Optionally, remove the student from the simulation
            ; die
          ]
        ]
      ]
    ]
  ]
end

; Update plots and monitors
to do-plots
  ; Plot economic condition
  set-current-plot "Economic Condition"
  plot economic-condition
  
  ; Plot total internships offered
  set-current-plot "Internships Offered"
  plot sum [ internships-offered ] of companies
  
  ; Plot average skill alignment
  set-current-plot "Average Skill Alignment"
  plot mean [ skill-alignment ] of students
end
