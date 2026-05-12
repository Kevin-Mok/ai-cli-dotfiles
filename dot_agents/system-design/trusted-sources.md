# Trusted Sources and Categorization System

Date: 2026-05-09

## 1. Purpose

The platform should never treat AI-generated teaching material as source-free content.

Every lesson, worksheet, practice question, quiz, assessment, rubric, explanation, or parent/student feedback draft should connect back to a trusted source or a teacher-approved internal standard.

Core rule:

```text
No source, no approved material.
```

The platform should support three related goals:

1. Help Triway and Maxfield prepare material faster.
2. Protect quality by grounding output in trusted sources.
3. Protect the future SaaS business by tracking source rights and avoiding unsafe content reuse.

## 2. Source Strategy

The source library should separate two ideas:

- **Trust**: Is this source educationally reliable?
- **Rights**: Are we allowed to copy, adapt, display, or commercialize this source?

A source can be highly trustworthy but still not safe to copy into a commercial product. For example, official contest problems can be excellent teaching references, but the platform should still confirm commercial reuse rights before including original problems in a paid product.

Recommended principle:

```text
Use official and trusted sources for alignment.
Use owned, licensed, public-domain, or clearly permitted content for product output.
Use restricted sources only for reference, inspiration, or internal review unless permission is confirmed.
```

## 3. Trusted Source List

### 3.1 Internal Owned Sources

These should be the highest-priority sources for product generation because they reflect the school's own teaching style and are easiest to reuse if ownership is clear.

Examples:

- Triway teacher-created worksheets
- Triway contest-prep notes
- Triway coding exercises
- Triway class slides and homework
- Maxfield course outlines
- Maxfield lesson plans
- Maxfield teacher-created assignments
- Maxfield rubrics and sample feedback
- School-created student practice banks
- Teacher-authored explanations and answer keys

Usage status:

- Best for generation and commercial product workflows if ownership is confirmed.
- Should still be tagged by author, owner, creation date, and permission status.

### 3.2 Ontario Curriculum, Policy, and OSSD Sources

These are essential for Maxfield and any Ontario private high school package.

Trusted sources:

- [Ontario Curriculum and Resources](https://www.dcp.edu.gov.on.ca/resources/en)  
  Official curriculum expectations and learning resources.

- [Ontario Ministry of Education](https://www.ontario.ca/page/ministry-education)  
  Official ministry context for curriculum, assessment, EQAO, TVO, OSSD, and private schools.

- [Ontario private schools](https://www.ontario.ca/page/private-schools)  
  Official private-school requirements and inspection context.

- [Private schools: Notice of intention and pre-inspection materials](https://www.ontario.ca/page/private-schools-notice-intention-operate-private-school)  
  Useful for course calendar, course-of-study, timetable, inspection, classroom visit, and online-school preparation.

- [Ontario secondary school courses and related procedures](https://www.ontario.ca/document/ontario-schools-kindergarten-grade-12-policy-and-program-requirements/secondary-school-courses-and-related-procedures)  
  Useful for understanding course organization by discipline, grade, and course type.

- [Growing Success](https://www.ontario.ca/page/growing-success-assessment-evaluation-and-reporting-ontario-schools-kindergarten-grade-12)  
  Main Ontario assessment, evaluation, and reporting reference.

- [Student assessment, evaluations and report cards](https://www.ontario.ca/page/student-assessment-evaluations-and-report-cards)  
  Parent-facing Ontario assessment and reporting explanation.

Usage status:

- Use for curriculum alignment, expectations, assessment language, policy framing, rubrics, and report-comment structure.
- Do not imply Ministry endorsement.
- Store exact curriculum/code references when generating school materials.

### 3.3 Ontario Assessment Sources

These sources are useful for assessment format, released examples, and readiness practice.

Trusted sources:

- [EQAO Grade 9 Mathematics](https://www.eqao.com/the-assessments/grade-9-math/)  
  Includes framework, sample test, released questions, formula sheet, glossaries, and assessment information.

- [EQAO OSSLT](https://www.eqao.com/the-assessments/osslt/)  
  Includes framework, practice test, administration guidance, question types, and literacy-test readiness information.

Usage status:

- Good for alignment, practice format, topic coverage, and example-style analysis.
- Confirm terms before copying released questions into a commercial product.
- Better product approach: generate original questions aligned to EQAO strands and question formats, with source citation back to EQAO framework/released-sample reference.

### 3.4 TVO / Ontario Learning Sources

Trusted sources:

- [TVO Learn Grade 9-12 resources](https://tvolearn.com/collections/courses)  
  Ontario-aligned secondary learning resources.

- [TVO Learn teacher resources](https://tvolearn.com/pages/for_teachers)  
  Teacher-facing learning activities, toolkits, and modules.

- [TVO ILC](https://www.ilc.org/)  
  Ontario online high school and OSSD course context.

- [TVO ILC OSSD requirements](https://www.ilc.org/pages/what-we-offer-ossd)  
  Useful reference for OSSD requirement planning.

Usage status:

- Useful for Ontario course planning, learning-objective alignment, and student support.
- Confirm reuse terms before copying full content.
- Use as reference and alignment source unless permission allows direct adaptation.

### 3.5 Canadian Math and Computing Contest Sources

These are especially important for Triway.

Trusted sources:

- [CEMC Tools and Resources](https://cemc.uwaterloo.ca/resources)  
  Waterloo CEMC resources for mathematics and computer science.

- [CEMC Past Contests, Solutions and Results](https://cemc.uwaterloo.ca/resources/past-contests)  
  Past contest PDFs, solutions, results, and commentary.

- [CEMC Problem Set Generator](https://cemc.uwaterloo.ca/resources/problem-set-generator)  
  Generates problem sets from past Gauss, Pascal, Cayley, and Fermat contests.

- [CEMC Courseware](https://cemc.uwaterloo.ca/resources/courseware)  
  Free online math and computer science lessons, activities, enrichment challenges, and practice.

- [CEMC Contests](https://cemc.uwaterloo.ca/contests)  
  Official contest information for Gauss, PCF, Euclid, CCC, BCC, and other contests.

- [CEMC Canadian Computing Competition](https://cemc.uwaterloo.ca/contests/ccc)  
  CCC overview, rules, format, preparation, and official context.

- [CEMC Beaver Computing Challenge](https://cemc.uwaterloo.ca/contests/bcc)  
  Computing and logic contest for younger students.

Usage status:

- Very strong for contest-prep alignment.
- Use original CEMC material carefully.
- For commercial platform output, prefer teacher-created original variants inspired by skills/topics, not copied contest questions, unless permission is confirmed.
- Store lineage like: "Aligned to CEMC Gauss Grade 8, Part B, geometry reasoning" rather than claiming a generated question is a CEMC question.

### 3.6 AP, SAT, and International Pathway Sources

Useful for Maxfield Grade 11/12 and international-student pathways.

Trusted sources:

- [AP Courses and Exams](https://apcentral.collegeboard.org/courses)  
  Official College Board AP course list and course pages.

- [AP Calculus AB](https://apcentral.collegeboard.org/courses/ap-calculus-ab)  
  Official AP Calculus course and exam description.

- [AP Biology](https://apcentral.collegeboard.org/courses/ap-biology)  
  Official AP Biology course and exam description.

- [AP Computer Science Principles](https://apcentral.collegeboard.org/courses/ap-computer-science-principles)  
  Official AP CSP course overview and framework.

- [AP Computer Science A](https://apstudents.collegeboard.org/courses/ap-computer-science-a)  
  Student-facing official course overview, Java focus, and exam information.

- [College Board Bluebook practice](https://bluebook.collegeboard.org/students/practice)  
  Official SAT/PSAT digital practice environment.

- [SAT Suite practice tests](https://satsuite.collegeboard.org/practice/practice-tests/bluebook)  
  Official SAT practice-test information and Student Question Bank context.

Usage status:

- Use for framework alignment, course planning, exam skills, and practice structure.
- Do not copy official AP/SAT questions into paid product content unless licensed.
- Generate original practice aligned to skills and topics.

### 3.7 Open Educational Resources

These can be useful for lesson explanations, examples, and background content, but licenses must be tracked.

Trusted sources:

- [OpenStax](https://openstax.org/) and [OpenStax licensing](https://help.openstax.org/s/article/Licensing-information-of-OpenStax-textbooks)  
  High-quality open textbooks. License varies by book and must be checked. Some content is CC BY; some is CC BY-NC-SA.

- [CK-12 Foundation](https://www.ck12info.org/about-us/)  
  Free STEM resources, concepts, FlexBooks, and adaptive materials.

- [PhET Interactive Simulations](https://phet.colorado.edu/) and [PhET licensing help](https://phet.colorado.edu/en/help-center/getting-started)  
  Research-based interactive math and science simulations.

- [Project Gutenberg](https://www.gutenberg.org/) and [Project Gutenberg permissions](https://www.gutenberg.org/policy/permission)  
  Useful for public-domain-style literature passages, especially older texts, but Canada/US copyright differences must be checked.

- [Library of Congress Education Resources](https://www.loc.gov/education/)  
  Useful for primary sources, history, media literacy, and inquiry tasks.

Current English pilot sources loaded into the MVP:

- [Aesop's Fables; a new translation](https://www.gutenberg.org/ebooks/11339), Project Gutenberg eBook #11339
- [Alice's Adventures in Wonderland](https://www.gutenberg.org/ebooks/11), Project Gutenberg eBook #11
- [The Gift of the Magi](https://www.gutenberg.org/ebooks/7256), Project Gutenberg eBook #7256
- [Ontario English Language curriculum page](https://www.dcp.edu.gov.on.ca/resources/en/subjects/english-language), used for alignment guidance only

Usage status:

- Good for enrichment, reading passages, background, and concept explanations.
- Always store exact license and attribution requirements.
- Beware of NonCommercial and ShareAlike restrictions if the future platform is sold as SaaS.

### 3.8 Free Worksheet Sources with Restricted Educator-Use Terms

These sources can be useful for classroom practice and teacher preparation, but they are not automatically safe for commercial SaaS reuse.

Trusted sources:

- [Math-Drills.com](https://math-drills.com/) and [Math-Drills.com Terms of Use](https://math-drills.com/terms.php)  
  Large free math worksheet library covering arithmetic, algebra, decimals, fractions, geometry, measurement, money, number lines, order of operations, percentages, place value, statistics, time, word problems, seasonal math, flash cards, and related practice.

Usage status:

- Useful for Triway teachers and Maxfield teachers to find extra basic-skills practice.
- Useful for topic coverage ideas, worksheet structure, and skill sequencing.
- Keep Math-Drills attribution when using worksheets according to their terms.
- Do not upload Math-Drills worksheets into a paid SaaS product, redistribute them, remove attribution, or treat them as school-owned content.
- For platform generation, use as `reference_only` or `free_educator_use_restricted` unless explicit permission is obtained from Math-Drills.
- Best platform approach: generate original school-owned skill-practice worksheets inspired by the skill category, not copied from Math-Drills worksheet content.

### 3.9 Programming Language and Technology Sources

Trusted sources:

- [Python documentation](https://docs.python.org/3/) and [Python license](https://docs.python.org/3/license.html)  
  Official Python language and library documentation.

- [Python Software Foundation](https://www.python.org/psf/about/)  
  Official organization behind Python.

- [Oracle Java documentation](https://docs.oracle.com/java/)  
  Official Java documentation and API references.

- [Java SE documentation](https://www.oracle.com/java/technologies/javase-documentation.html)  
  Official Java SE documentation hub.

- [MDN Web Docs](https://developer.mozilla.org/en-US/docs/MDN) and [MDN content license context](https://developer.mozilla.org/en-US/docs/MDN/About)  
  Trusted documentation for HTML, CSS, JavaScript, and web APIs.

- [DMOJ](https://dmoj.ca/) and [DMOJ about](https://dmoj.ca/about/)  
  Online judge and programming-problem archive used heavily in Canadian contest-prep communities.

Usage status:

- Official docs are excellent for language correctness and terminology.
- DMOJ is useful for practice and judging references, but do not scrape or reuse problem statements commercially without permission. DMOJ has explicit AI/training restrictions and source/usage policies should be respected.

### 3.10 Licensed Commercial Sources

Examples:

- Commercial textbooks
- Paid worksheet banks
- Publisher-provided test banks
- Licensed AP/SAT prep books
- Purchased online course materials
- Third-party curriculum packages

Usage status:

- Only ingest if the school has rights to use the content in the platform.
- Track license scope carefully:
  - internal classroom use
  - online display
  - derivative works allowed
  - commercial SaaS use allowed
  - AI processing allowed
  - expiration date

### 3.11 Sources to Avoid or Restrict

Avoid using these as generation sources unless permission is clear:

- Random worksheet websites with unclear authorship
- Scanned commercial textbook pages
- Paid test-prep content copied from books or courses
- Student-submitted work containing personal information
- Forum posts, social media, or answer sites
- AI-generated content with no source lineage
- Any source that says no scraping, no AI training, no commercial reuse, or no redistribution

## 4. Source Trust Levels

Recommended trust levels:

| Level | Label | Meaning | Use |
| --- | --- | --- | --- |
| T0 | School-owned approved | Created and approved by Triway, Maxfield, or client school | Best source for generation |
| T1 | Official curriculum / policy | Government, ministry, official curriculum body | Alignment and compliance |
| T2 | Official exam / contest | EQAO, CEMC, College Board, official released examples | Format and skill alignment |
| T3 | Institution-grade OER | OpenStax, CK-12, PhET, university courseware | Concept support and enrichment |
| T4 | Licensed commercial | Publisher or vendor content with explicit rights | Use according to license |
| T5 | Public domain / primary source | Public-domain literature, primary-source archives | Reading/history/enrichment |
| T6 | Teacher draft | Created by a teacher but not yet approved | Internal draft only |
| T7 | Web reference only | Useful background but not controlled enough | Do not generate student-ready content directly |
| T8 | Blocked | Unclear, unsafe, restricted, or PII-heavy | Do not ingest |

## 5. Rights Categories

Every source should have a rights category separate from trust level.

| Rights Category | Meaning | Product Rule |
| --- | --- | --- |
| `owned_by_school` | Created by school or assigned to school | Can use if ownership confirmed |
| `teacher_created_assigned` | Teacher-created and licensed/assigned to school | Can use after approval |
| `licensed_commercial` | Explicit vendor/publisher license | Use only within license scope |
| `official_reference` | Official source for alignment but rights unclear for copying | Cite and align, do not copy |
| `open_cc_by` | Creative Commons Attribution | Can adapt with attribution |
| `open_cc_by_sa` | Attribution + ShareAlike | Adapt carefully; share-alike may affect product output |
| `open_cc_by_nc` | NonCommercial restriction | Avoid in paid SaaS output unless permission confirmed |
| `free_educator_use_restricted` | Free for teachers/tutors/students under site terms but not open commercial reuse | Use for internal educator workflows only; do not redistribute in SaaS without permission |
| `public_domain_check_required` | Likely public domain but jurisdiction matters | Legal/copyright check before reuse |
| `reference_only` | Use for teacher background only | Do not output copied/adapted student material |
| `blocked` | No permission, PII, or unsafe | Do not use |

## 6. Core Categorization System

The platform should categorize every source, chunk, generated question, worksheet, and assignment with a common metadata system.

### 6.1 Source Metadata

Required fields:

```json
{
  "source_id": "src_...",
  "title": "Grade 8 Ratio Practice Set",
  "source_owner": "Triway Education",
  "source_author": "Teacher name or organization",
  "source_origin": "school_owned | official | oer | licensed | web_reference",
  "trust_level": "T0",
  "rights_category": "owned_by_school",
  "license_notes": "Owned by Triway. Approved for internal platform use.",
  "url": null,
  "publication_date": "2026-05-09",
  "ingested_at": "2026-05-09",
  "review_status": "approved | needs_review | blocked",
  "approved_by": "teacher_or_admin_id",
  "allowed_use": ["internal_generation", "student_display", "worksheet_export"],
  "blocked_use": ["public_resale_without_review"]
}
```

### 6.2 Academic Metadata

Required fields:

```json
{
  "institution_type": "tutoring_school | private_high_school",
  "school_id": "triway | maxfield | client_school",
  "program": "contest_prep | ossd_credit | ap_prep | coding | enrichment",
  "subject": "mathematics",
  "course_code": "MTH1W | MPM2D | MCR3U | MHF4U | MCV4U | ICS3U | ENG4U",
  "grade": "8 | 9 | 10 | 11 | 12",
  "curriculum": "Ontario | CEMC | AP | SAT | school_internal",
  "strand": "Number | Algebra | Data | Geometry | Financial Literacy",
  "unit": "Linear Relations",
  "topic": "slope",
  "subtopic": "rate of change from graph",
  "learning_goal": "Find and interpret slope from a graph",
  "curriculum_expectation": "official code or school-defined expectation",
  "language": "en | fr | zh | bilingual"
}
```

### 6.3 Question Metadata

Recommended fields:

```json
{
  "question_id": "q_...",
  "source_ids": ["src_..."],
  "source_chunk_ids": ["chunk_..."],
  "generation_type": "original | variation | aligned_practice | teacher_authored",
  "generation_profile_id": "gp_...",
  "generation_profile_version": 3,
  "derivation_notes": "Original teacher-approved variant aligned to CEMC-style proportional reasoning.",
  "question_type": "multiple_choice | numeric | short_answer | proof | coding | essay",
  "answer_type": "choice | integer | decimal | fraction | expression | text | code",
  "grading_mode": "auto_grade | ai_assisted_teacher_review | teacher_review_only",
  "difficulty": "easy | medium | hard | contest_part_a | contest_part_b | contest_part_c",
  "difficulty_level": "D1 | D2 | D3 | D4 | D5",
  "difficulty_label": "scaffolded | basic | standard | challenging | extension",
  "difficulty_source": "teacher | source_anchor | ai_estimate | observed_performance",
  "difficulty_factors": {
    "step_count": 2,
    "concept_count": 1,
    "reading_load": "low | medium | high",
    "calculation_complexity": "low | medium | high",
    "abstraction": "concrete | mixed | abstract",
    "novelty": "familiar | transfer | novel"
  },
  "cognitive_level": "remember | understand | apply | analyze | evaluate | create",
  "ontario_achievement_category": "knowledge | thinking | communication | application",
  "assessment_purpose": "diagnostic | formative | homework | quiz | test | summative | enrichment",
  "assessment_usage_status": "practice_ok | assessment_candidate | assessment_approved | assessment_locked | not_for_assessment",
  "estimated_time_minutes": 3,
  "default_marks": 1,
  "visual_type": "none | graph | geometry | table | chart | code_trace | diagram",
  "learning_preview_status": "none | draft | needs_teacher_review | approved | rejected",
  "learning_preview_type": "none | deterministic_diagram | generated_image | storyboard | character_map | code_trace",
  "validation_method": "exact | numeric_tolerance | symbolic | test_cases | teacher_review",
  "validation_status": "verified | needs_review | failed | not_supported",
  "review_status": "draft | approved | rejected | archived"
}
```

### 6.4 Worksheet / Assignment Metadata

Recommended fields:

```json
{
  "assignment_id": "asgn_...",
  "assignment_type": "worksheet | online_practice | quiz | test | mock_contest | unit_review",
  "audience": "student | teacher | parent",
  "class_group": "Grade 8 Contest Prep Saturday",
  "course_code": "internal or Ontario code",
  "topic_mix": ["fractions", "ratio", "geometry"],
  "difficulty_mix": {
    "easy": 3,
    "medium": 5,
    "hard": 2
  },
  "source_coverage": ["src_...", "src_..."],
  "answer_key_included": true,
  "solution_steps_included": true,
  "teacher_approved_by": "teacher_id",
  "assigned_at": "2026-05-09"
}
```

### 6.5 Assessment / Exam Metadata

Recommended fields:

```json
{
  "assessment_id": "exam_...",
  "assessment_type": "quiz | unit_test | midterm | final | mock_contest | entrance_test | diagnostic",
  "audience": "student",
  "course_code": "internal or Ontario code",
  "class_group": "Grade 8 Contest Prep Saturday",
  "time_limit_minutes": 60,
  "total_marks": 50,
  "section_structure": [
    {
      "section_id": "part_a",
      "title": "Part A",
      "question_type_mix": ["multiple_choice"],
      "difficulty_levels": ["D1", "D2"],
      "marks": 15
    }
  ],
  "topic_coverage": ["ratio", "geometry", "number_sense"],
  "difficulty_mix": {
    "D1": 5,
    "D2": 5,
    "D3": 8,
    "D4": 5,
    "D5": 2
  },
  "question_type_mix": {
    "multiple_choice": 15,
    "short_answer": 8,
    "open_response": 2
  },
  "allowed_tools": ["calculator", "formula_sheet"],
  "source_coverage": ["src_...", "src_..."],
  "version_count": 2,
  "status": "draft | building | needs_review | ready_to_finalize | locked | published | archived",
  "locked_by": "teacher_id",
  "locked_at": "2026-05-09"
}
```

Assessment items should store:

- assessment section
- question version
- marks
- order
- source lineage
- difficulty level
- validation status
- teacher approval status
- rubric reference

Do not use uncleared reference-only source material for commercial exam output. For contests, generate original teacher-reviewed questions aligned to skills and difficulty, not copied contest questions.

### 6.6 Result / Marking Metadata

Recommended attempt result fields:

```json
{
  "attempt_id": "attempt_...",
  "student_id": "student_...",
  "assignment_id": "asgn_...",
  "assessment_id": "exam_...",
  "package_version": 1,
  "score": 42,
  "max_score": 50,
  "percentage": 84,
  "grading_status": "auto_graded | pending_teacher_review | teacher_adjusted | finalized",
  "auto_graded_count": 22,
  "pending_review_count": 3,
  "topic_breakdown": {
    "ratio": {
      "score": 8,
      "max_score": 10
    }
  },
  "difficulty_breakdown": {
    "D1": {
      "score": 5,
      "max_score": 5
    },
    "D4": {
      "score": 6,
      "max_score": 10
    }
  },
  "summary_release_status": "hidden | student_visible | teacher_only",
  "finalized_by": "teacher_id",
  "finalized_at": "2026-05-09"
}
```

Recommended per-answer grading fields:

- grading method: exact, numeric tolerance, symbolic, test cases, rubric assisted, manual
- marks earned
- max marks
- correctness status
- feedback release status
- teacher adjustment reason
- pending review reason

Student-visible summaries should not include answer-key internals, hidden tests, teacher-only rubric notes, or source-rights internals.

## 7. Course and Subject Category System

### 7.1 Top-Level Programs

Use these program categories:

- `triway_contest_math`
- `triway_coding`
- `triway_school_math`
- `triway_english`
- `triway_french`
- `maxfield_ossd_credit`
- `maxfield_ap_prep`
- `maxfield_international_student_support`
- `client_tutoring_school`
- `client_private_school`

### 7.2 Main Subjects

Use stable subject categories:

- Mathematics
- Computer Science / Coding
- English
- French
- Science
- Business
- Canadian and World Studies
- Social Science and Humanities
- Guidance / Career Education
- Technology
- Arts
- Health and Physical Education
- Admissions / Student Support
- Parent Communication

### 7.3 Ontario Course Codes

The system should store course codes where relevant.

Examples from Maxfield's current course list:

- Grade 9: `ENG1D`, `MTH1W` or local legacy code, `SNC1D`, `FSF1D`, `CGC1D`
- Grade 10: `ENG2D`, `MPM2D`, `SNC2D`, `CHC2D`, `CHV2O`, `GLC2O`
- Grade 11: `ENG3U`, `MCR3U`, `MCF3M`, `SPH3U`, `SCH3U`, `SBI3U`, `ICS3U`
- Grade 12: `ENG4U`, `MHF4U`, `MCV4U`, `MDM4U`, `SBI4U`, `SCH4U`, `SPH4U`, `ICS4U`

Note:

- Course codes should be reviewed against current Ontario curriculum before official use.
- Some old course-code spellings on public websites may have typos or outdated labels.

### 7.4 Contest and Exam Categories

Use separate categories for contest/exam preparation:

- CEMC Gauss Grade 7
- CEMC Gauss Grade 8
- CEMC Pascal Grade 9
- CEMC Cayley Grade 10
- CEMC Fermat Grade 11
- CEMC Euclid Grade 12
- Canadian Computing Competition Junior
- Canadian Computing Competition Senior
- Beaver Computing Challenge Grade 5/6
- Beaver Computing Challenge Grade 7/8
- Beaver Computing Challenge Grade 9/10
- EQAO Grade 9 Math
- OSSLT
- AP Calculus AB/BC
- AP Computer Science A
- AP Computer Science Principles
- AP Biology
- AP Chemistry
- AP Physics
- SAT Math
- SAT Reading and Writing

## 8. Learning and Assessment Categories

### 8.1 Assessment Purpose

Every generated item should specify one purpose:

- Diagnostic
- Lesson check
- Homework practice
- Exit ticket
- Quiz
- Unit test
- Mock contest
- Exam prep
- Summative assessment
- Culminating task
- Intervention / remediation
- Enrichment / challenge

### 8.2 Ontario Achievement Categories

For Ontario private high school materials, tag assessment items with:

- Knowledge and Understanding
- Thinking
- Communication
- Application

These should be used especially for rubrics, assignments, report comments, and course assessments.

### 8.3 Cognitive Level

Use Bloom-style thinking categories:

- Remember
- Understand
- Apply
- Analyze
- Evaluate
- Create

For contest preparation, use a simpler contest difficulty category too:

- Part A / easy
- Part B / medium
- Part C / hard
- Euclid full solution
- CCC Junior
- CCC Senior

### 8.4 Difficulty Level

Use a normalized D1-D5 level for every question.

| Level | Label | Meaning |
| --- | --- | --- |
| `D1` | Scaffolded | direct recall, one concept, guided or very low reading/calculation load |
| `D2` | Basic | one main skill, simple numbers, familiar setup |
| `D3` | Standard | grade-level practice, 2-3 steps, normal wording |
| `D4` | Challenging | multi-step or multi-concept, less direct setup, higher reasoning load |
| `D5` | Extension | contest-style, proof/analysis, transfer, or open-ended high independence |

Do not define difficulty only by grade. A Grade 7 question can be D1 or D5 depending on the task.

Difficulty should consider:

- prerequisite count
- concept count
- step count
- reading load
- vocabulary load
- calculation complexity
- abstraction level
- novelty or transfer
- answer format complexity
- rubric complexity
- expected time

Initial difficulty sources:

- teacher rating
- source anchor, such as contest part or question number
- AI estimate from structured generation
- imported source metadata

Observed difficulty sources after launch:

- correct rate
- median completion time
- hint usage
- retry count
- abandon rate
- teacher adjustment

For CEMC-style contests, Part A can map roughly to D1-D2, Part B to D3-D4, and Part C to D5, then the teacher can override. For English, difficulty should consider passage length, vocabulary, literal vs inferential reasoning, evidence requirement, and writing load.

Observed student performance should improve recommendations, but it should not silently overwrite teacher-approved difficulty metadata.

### 8.5 Question Formats

Use consistent question types:

- Multiple choice
- Multi-select
- Numeric response
- Fraction response
- Algebraic expression
- Equation solving
- Short answer
- Long answer
- Proof / justification
- Reading comprehension
- Essay / paragraph
- Coding problem
- Code tracing
- Debugging
- Data interpretation
- Diagram / graph interpretation
- Matching
- Drag/drop style

### 8.6 Validation Categories

The platform should know how each answer can be checked:

- Exact choice
- Integer equality
- Decimal tolerance
- Fraction equivalence
- Symbolic equivalence
- Unit-aware numeric answer
- Set/list equality
- Code sample tests
- Code hidden tests
- Rubric-assisted teacher review
- Manual review only

## 9. Source Workflow

Recommended source workflow:

```text
1. Add source
2. Record rights and trust level
3. Tag subject/course/topic
4. Chunk source into searchable sections
5. Teacher/admin reviews source
6. Source becomes trusted for generation
7. AI generates draft material with source citations
8. Validator checks what can be checked
9. Teacher approves output
10. Approved output becomes reusable school material
```

### 9.1 Ingestion Checklist

Before a source can be used:

- Is the source owner known?
- Is the author known?
- Is the source date/version known?
- Is the license or permission status known?
- Is the content appropriate for the grade?
- Is the content aligned to a subject/course/topic?
- Does it contain student PII?
- Is it allowed for AI processing?
- Is it allowed for student display?
- Is it allowed for worksheet export?
- Is it allowed for commercial SaaS use?

### 9.2 Output Checklist

Before AI-generated material is approved:

- Does it cite source IDs?
- Does it list topic/grade/course tags?
- Does the answer match the question?
- Are solution steps correct?
- Is the difficulty appropriate?
- Is wording age-appropriate?
- Is the content original enough when based on restricted sources?
- Has a teacher approved it?
- Is the usage allowed under the source rights category?

## 10. Recommended First Implementation

For Triway:

```text
Start with T0 school-owned questions and T2 CEMC alignment references.
Generate original Grade 7/8 contest-style variants.
Use CEMC as topic/format alignment, not copied product content.
Use Math-Drills as optional teacher-facing basic-skills reference only, not copied SaaS content.
```

For Maxfield:

```text
Start with T0 Maxfield-owned course materials and T1 Ontario curriculum/policy references.
Generate course-aligned lesson support, quizzes, rubrics, and progress-comment drafts.
Keep teacher/principal approval before use in credit-course workflows.
```

For future client schools:

```text
Each school gets a private source library.
Each school gets a private Markdown Knowledge Vault.
No source material crosses between schools.
Every generated item keeps source lineage and rights metadata.
```

## 11. Knowledge Base Categorization

The Knowledge Base should use Obsidian-style Markdown notes as the source of truth.

Recommended KnowledgeNote properties:

```yaml
id: kb_...
type: concept | topic | skill | common_mistake | curriculum_expectation | teaching_strategy
status: draft | needs_review | approved | archived
subject: math
grade_levels: [7]
programs: [triway_contest_math]
topic: ratio_and_proportion
difficulty_range: [D2, D4]
source_anchors:
  - source_id: src_...
    anchor_id: anchor_...
    rights_category: teacher_owned
relationships:
  - type: prerequisite_of
    target: "[[Proportional Reasoning]]"
approved_by: teacher_id
approved_at: 2026-05-09
```

The database can index these properties for filtering and graph navigation, but KB note content should remain in the Markdown Knowledge Vault.

No vector database or embedding index is required for the core categorization system. The AI-native path is explicit Markdown notes, properties, links, backlinks, source anchors, and teacher-approved context bundles.

## 12. Minimum Source Library Tables

The future database should include:

- `source_documents`
- `source_import_jobs`
- `source_chunks`
- `knowledge_vaults`
- `knowledge_note_index`
- `knowledge_link_index`
- `source_permissions`
- `source_reviews`
- `curriculum_mappings`
- `generated_items`
- `question_versions`
- `validation_runs`
- `teacher_reviews`
- `assignment_sources`

Most important fields:

- `school_id`
- `source_id`
- `chunk_id`
- `trust_level`
- `rights_category`
- `allowed_use`
- `subject`
- `grade`
- `course_code`
- `curriculum`
- `strand`
- `topic`
- `source_url`
- `source_entry_method`
- `source_fetch_status`
- `fetched_at`
- `content_type`
- `content_length`
- `content_hash`
- `stored_object_path`
- `source_version`
- `license_notes`
- `review_status`
- `approved_by`

## 13. Summary

The platform's content advantage should come from a strong source system, not from asking AI to invent material from nowhere.

Best strategy:

```text
Official sources define standards.
School-owned sources define style.
Open/licensed sources enrich content.
Teacher review protects quality.
Source metadata protects the business.
```
