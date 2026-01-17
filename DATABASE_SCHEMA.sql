-- AI Drug Discovery Platform Database Schema
-- SQLite compatible schema for offline operation

-- ============================================================================
-- DISEASE DATABASE
-- ============================================================================

CREATE TABLE diseases (
    disease_id INTEGER PRIMARY KEY AUTOINCREMENT,
    disease_name TEXT NOT NULL UNIQUE,
    icd10_code TEXT,
    icd11_code TEXT,
    disease_category TEXT, -- e.g., 'oncology', 'cardiovascular', 'rare disease'
    prevalence_global INTEGER, -- estimated number of patients
    prevalence_source TEXT,
    mortality_rate REAL, -- annual mortality rate
    unmet_need_score REAL, -- calculated score 0-100
    market_size_usd REAL, -- estimated market size in USD
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE failed_drugs (
    failed_drug_id INTEGER PRIMARY KEY AUTOINCREMENT,
    disease_id INTEGER NOT NULL,
    drug_name TEXT NOT NULL,
    mechanism_of_action TEXT,
    modality TEXT, -- 'small molecule', 'antibody', 'ADC', 'peptide', etc.
    failure_phase TEXT, -- 'Phase I', 'Phase II', 'Phase III', 'Post-approval'
    failure_reason TEXT, -- 'lack of efficacy', 'toxicity', 'PK issues', etc.
    failure_details TEXT, -- detailed description
    clinical_trial_id TEXT, -- NCT number
    company TEXT,
    year_failed INTEGER,
    reference_url TEXT,
    reference_pmid TEXT,
    lessons_learned TEXT, -- AI-extracted insights
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (disease_id) REFERENCES diseases(disease_id)
);

CREATE TABLE unmet_needs (
    unmet_need_id INTEGER PRIMARY KEY AUTOINCREMENT,
    disease_id INTEGER NOT NULL,
    need_category TEXT, -- 'efficacy', 'safety', 'delivery', 'patient compliance'
    need_description TEXT,
    severity_score REAL, -- 0-10 scale
    evidence_level TEXT, -- 'high', 'medium', 'low'
    reference_pmid TEXT,
    reference_url TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (disease_id) REFERENCES diseases(disease_id)
);

-- ============================================================================
-- PATHOBIOLOGY DATABASE
-- ============================================================================

CREATE TABLE biological_entities (
    entity_id INTEGER PRIMARY KEY AUTOINCREMENT,
    entity_name TEXT NOT NULL UNIQUE,
    entity_type TEXT NOT NULL, -- 'protein', 'receptor', 'enzyme', 'cell_type', 'pathway'
    uniprot_id TEXT,
    gene_symbol TEXT,
    ensembl_id TEXT,
    protein_class TEXT, -- 'GPCR', 'kinase', 'protease', etc.
    tissue_expression TEXT, -- comma-separated tissues
    subcellular_location TEXT,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE disease_biology (
    disease_biology_id INTEGER PRIMARY KEY AUTOINCREMENT,
    disease_id INTEGER NOT NULL,
    entity_id INTEGER NOT NULL,
    role_in_disease TEXT, -- 'driver', 'biomarker', 'therapeutic_target', 'prognostic'
    expression_change TEXT, -- 'upregulated', 'downregulated', 'mutated', 'overexpressed'
    fold_change REAL, -- expression fold change if available
    pathological_relevance TEXT, -- description of role
    validation_status TEXT, -- 'validated', 'emerging', 'hypothetical'
    evidence_level TEXT, -- 'strong', 'moderate', 'weak'
    reference_pmid TEXT,
    reference_doi TEXT,
    citation_count INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (disease_id) REFERENCES diseases(disease_id),
    FOREIGN KEY (entity_id) REFERENCES biological_entities(entity_id)
);

CREATE TABLE pathways (
    pathway_id INTEGER PRIMARY KEY AUTOINCREMENT,
    pathway_name TEXT NOT NULL UNIQUE,
    pathway_database TEXT, -- 'KEGG', 'Reactome', 'WikiPathways'
    pathway_external_id TEXT,
    pathway_category TEXT, -- 'signaling', 'metabolic', 'immune'
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE disease_pathways (
    disease_pathway_id INTEGER PRIMARY KEY AUTOINCREMENT,
    disease_id INTEGER NOT NULL,
    pathway_id INTEGER NOT NULL,
    dysregulation_type TEXT, -- 'activated', 'inhibited', 'disrupted'
    relevance_description TEXT,
    reference_pmid TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (disease_id) REFERENCES diseases(disease_id),
    FOREIGN KEY (pathway_id) REFERENCES pathways(pathway_id)
);

CREATE TABLE pathway_entities (
    pathway_entity_id INTEGER PRIMARY KEY AUTOINCREMENT,
    pathway_id INTEGER NOT NULL,
    entity_id INTEGER NOT NULL,
    role_in_pathway TEXT, -- 'upstream', 'downstream', 'regulator'
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (pathway_id) REFERENCES pathways(pathway_id),
    FOREIGN KEY (entity_id) REFERENCES biological_entities(entity_id)
);

-- ============================================================================
-- PEPTIDE DATABASE
-- ============================================================================

CREATE TABLE peptides (
    peptide_id INTEGER PRIMARY KEY AUTOINCREMENT,
    peptide_name TEXT,
    sequence TEXT NOT NULL, -- single letter amino acid code
    sequence_length INTEGER,
    molecular_weight REAL,
    isoelectric_point REAL,
    hydrophobicity_score REAL,
    net_charge REAL,
    function_category TEXT, -- 'targeting', 'therapeutic', 'CPP', 'enzyme_substrate'
    modifications TEXT, -- e.g., 'N-term acetylation', 'C-term amidation'
    d_amino_acids BOOLEAN DEFAULT 0, -- contains D-amino acids for stability
    cyclization TEXT, -- 'linear', 'cyclic', 'bicyclic'
    synthesis_complexity TEXT, -- 'simple', 'moderate', 'complex'
    synthesis_feasibility_score REAL, -- 0-10 scale
    commercial_availability TEXT, -- vendor names if available
    cost_estimate_per_mg REAL,
    structure_pdb_id TEXT, -- if 3D structure available
    immunogenicity_risk TEXT, -- 'low', 'medium', 'high'
    stability_serum TEXT, -- 'poor', 'moderate', 'good', 'excellent'
    half_life_serum_hours REAL,
    permeability TEXT, -- 'cell_penetrating', 'non_permeable', 'moderate'
    description TEXT,
    original_source TEXT, -- 'synthetic', 'natural', 'phage_display', 'rational_design'
    reference_pmid TEXT,
    reference_doi TEXT,
    database_source TEXT, -- 'PepBank', 'APD3', 'SATPdb', etc.
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE peptide_targets (
    peptide_target_id INTEGER PRIMARY KEY AUTOINCREMENT,
    peptide_id INTEGER NOT NULL,
    entity_id INTEGER NOT NULL,
    interaction_type TEXT, -- 'agonist', 'antagonist', 'binder', 'substrate'
    binding_affinity_kd REAL, -- dissociation constant in nM
    binding_affinity_ic50 REAL, -- IC50 in nM if applicable
    specificity_score REAL, -- 0-10 scale
    validation_method TEXT, -- 'SPR', 'ITC', 'cell_assay', 'in_vivo'
    off_target_known BOOLEAN DEFAULT 0,
    off_target_description TEXT,
    reference_pmid TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (peptide_id) REFERENCES peptides(peptide_id),
    FOREIGN KEY (entity_id) REFERENCES biological_entities(entity_id)
);

CREATE TABLE peptide_therapeutic_effects (
    therapeutic_effect_id INTEGER PRIMARY KEY AUTOINCREMENT,
    peptide_id INTEGER NOT NULL,
    disease_id INTEGER,
    effect_type TEXT, -- 'cytotoxic', 'immunomodulatory', 'pro-apoptotic', etc.
    effect_description TEXT,
    efficacy_data TEXT, -- IC50, EC50, other metrics
    in_vitro_validated BOOLEAN DEFAULT 0,
    in_vivo_validated BOOLEAN DEFAULT 0,
    clinical_stage TEXT, -- 'preclinical', 'Phase I', etc.
    reference_pmid TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (peptide_id) REFERENCES peptides(peptide_id),
    FOREIGN KEY (disease_id) REFERENCES diseases(disease_id)
);

CREATE TABLE enzyme_responsive_linkers (
    linker_id INTEGER PRIMARY KEY AUTOINCREMENT,
    linker_name TEXT NOT NULL,
    sequence TEXT, -- peptide sequence if peptide-based
    enzyme_target TEXT, -- 'MMP-2', 'MMP-9', 'cathepsin B', etc.
    entity_id INTEGER, -- links to enzyme in biological_entities
    cleavage_site TEXT,
    cleavage_efficiency TEXT, -- 'high', 'moderate', 'low'
    disease_specificity TEXT, -- diseases where enzyme is upregulated
    chemistry_type TEXT, -- 'peptide', 'ester', 'disulfide', 'pH-sensitive'
    stability TEXT,
    reference_pmid TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (entity_id) REFERENCES biological_entities(entity_id)
);

-- ============================================================================
-- DRUG CANDIDATE DATABASE
-- ============================================================================

CREATE TABLE drug_candidates (
    candidate_id INTEGER PRIMARY KEY AUTOINCREMENT,
    candidate_name TEXT NOT NULL UNIQUE,
    disease_id INTEGER NOT NULL,
    modality TEXT, -- 'liposome', 'LNP', 'hybrid'
    design_rationale TEXT, -- AI-generated explanation
    predicted_moa TEXT, -- mechanism of action
    targeting_strategy TEXT,
    therapeutic_strategy TEXT,
    cargo_type TEXT, -- 'small_molecule', 'siRNA', 'mRNA', 'none'
    cargo_identity TEXT, -- e.g., 'TXA', 'siRNA-BCL2'
    responsive_release BOOLEAN DEFAULT 0,
    responsive_mechanism TEXT,
    design_score REAL, -- overall AI ranking score 0-100
    specificity_score REAL,
    efficacy_prediction REAL,
    safety_score REAL,
    synthesis_feasibility_score REAL,
    cmc_complexity TEXT, -- 'simple', 'moderate', 'complex'
    off_target_risk TEXT, -- 'low', 'medium', 'high'
    off_target_details TEXT,
    immunogenicity_risk TEXT,
    estimated_cost_per_dose REAL,
    design_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status TEXT DEFAULT 'proposed', -- 'proposed', 'selected', 'in_testing', 'validated', 'failed'
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE candidate_peptide_components (
    component_id INTEGER PRIMARY KEY AUTOINCREMENT,
    candidate_id INTEGER NOT NULL,
    peptide_id INTEGER NOT NULL,
    component_role TEXT, -- 'targeting', 'therapeutic', 'CPP', 'linker'
    peptide_count_per_particle INTEGER, -- stoichiometry
    conjugation_method TEXT, -- 'maleimide', 'click_chemistry', 'post_insertion'
    position TEXT, -- 'surface', 'embedded', 'core'
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (candidate_id) REFERENCES drug_candidates(candidate_id),
    FOREIGN KEY (peptide_id) REFERENCES peptides(peptide_id)
);

CREATE TABLE candidate_formulation (
    formulation_id INTEGER PRIMARY KEY AUTOINCREMENT,
    candidate_id INTEGER NOT NULL UNIQUE,
    lipid_composition TEXT, -- JSON or text description
    particle_size_nm REAL,
    zeta_potential_mv REAL,
    pdi REAL, -- polydispersity index
    encapsulation_efficiency REAL,
    drug_loading REAL,
    formulation_notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (candidate_id) REFERENCES drug_candidates(candidate_id)
);

CREATE TABLE experimental_plans (
    plan_id INTEGER PRIMARY KEY AUTOINCREMENT,
    candidate_id INTEGER NOT NULL,
    experiment_type TEXT, -- 'binding', 'uptake', 'cytotoxicity', 'in_vivo'
    assay_description TEXT,
    cell_lines TEXT, -- comma-separated list
    protocol TEXT, -- step-by-step protocol
    materials_list TEXT,
    equipment_required TEXT,
    estimated_cost REAL,
    estimated_duration_days INTEGER,
    expected_outcome TEXT,
    decision_criteria TEXT, -- what constitutes success
    priority INTEGER, -- 1=highest priority
    status TEXT DEFAULT 'planned', -- 'planned', 'in_progress', 'completed'
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (candidate_id) REFERENCES drug_candidates(candidate_id)
);

CREATE TABLE experimental_results (
    result_id INTEGER PRIMARY KEY AUTOINCREMENT,
    plan_id INTEGER NOT NULL,
    result_data TEXT, -- JSON or structured text
    success BOOLEAN,
    observations TEXT,
    conclusions TEXT,
    next_steps TEXT,
    result_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (plan_id) REFERENCES experimental_plans(plan_id)
);

-- ============================================================================
-- INDEXES FOR QUERY OPTIMIZATION
-- ============================================================================

CREATE INDEX idx_diseases_category ON diseases(disease_category);
CREATE INDEX idx_diseases_unmet_score ON diseases(unmet_need_score);
CREATE INDEX idx_failed_drugs_disease ON failed_drugs(disease_id);
CREATE INDEX idx_disease_biology_disease ON disease_biology(disease_id);
CREATE INDEX idx_disease_biology_entity ON disease_biology(entity_id);
CREATE INDEX idx_peptide_targets_peptide ON peptide_targets(peptide_id);
CREATE INDEX idx_peptide_targets_entity ON peptide_targets(entity_id);
CREATE INDEX idx_peptides_function ON peptides(function_category);
CREATE INDEX idx_drug_candidates_disease ON drug_candidates(disease_id);
CREATE INDEX idx_drug_candidates_status ON drug_candidates(status);
CREATE INDEX idx_biological_entities_type ON biological_entities(entity_type);

-- ============================================================================
-- VIEWS FOR COMMON QUERIES
-- ============================================================================

CREATE VIEW disease_summary AS
SELECT
    d.disease_id,
    d.disease_name,
    d.disease_category,
    d.unmet_need_score,
    COUNT(DISTINCT fd.failed_drug_id) as failed_drug_count,
    COUNT(DISTINCT db.entity_id) as known_targets,
    COUNT(DISTINCT dc.candidate_id) as candidate_count
FROM diseases d
LEFT JOIN failed_drugs fd ON d.disease_id = fd.disease_id
LEFT JOIN disease_biology db ON d.disease_id = db.disease_id
LEFT JOIN drug_candidates dc ON d.disease_id = dc.disease_id
GROUP BY d.disease_id;

CREATE VIEW peptide_summary AS
SELECT
    p.peptide_id,
    p.peptide_name,
    p.sequence,
    p.function_category,
    p.synthesis_feasibility_score,
    COUNT(DISTINCT pt.entity_id) as target_count,
    AVG(pt.binding_affinity_kd) as avg_kd,
    COUNT(DISTINCT pte.disease_id) as disease_count
FROM peptides p
LEFT JOIN peptide_targets pt ON p.peptide_id = pt.peptide_id
LEFT JOIN peptide_therapeutic_effects pte ON p.peptide_id = pte.peptide_id
GROUP BY p.peptide_id;

CREATE VIEW top_unmet_needs AS
SELECT
    d.disease_name,
    d.disease_category,
    d.unmet_need_score,
    d.prevalence_global,
    d.market_size_usd,
    COUNT(DISTINCT fd.failed_drug_id) as failed_attempts,
    GROUP_CONCAT(DISTINCT un.need_category) as need_categories
FROM diseases d
LEFT JOIN failed_drugs fd ON d.disease_id = fd.disease_id
LEFT JOIN unmet_needs un ON d.disease_id = un.disease_id
GROUP BY d.disease_id
ORDER BY d.unmet_need_score DESC;

-- ============================================================================
-- SAMPLE DATA INSERTION (for testing)
-- ============================================================================

-- Insert sample disease
INSERT INTO diseases (disease_name, icd10_code, disease_category, prevalence_global, unmet_need_score, description)
VALUES ('Glioblastoma Multiforme', 'C71.9', 'oncology', 300000, 95.0, 'Aggressive brain cancer with poor prognosis and limited treatment options');

-- Insert sample biological entity
INSERT INTO biological_entities (entity_name, entity_type, uniprot_id, gene_symbol, description)
VALUES ('Epidermal Growth Factor Receptor', 'receptor', 'P00533', 'EGFR', 'Receptor tyrosine kinase involved in cell proliferation');

-- Insert sample peptide
INSERT INTO peptides (peptide_name, sequence, sequence_length, function_category, description)
VALUES ('GE11', 'YHWYGYTPQNVI', 12, 'targeting', 'EGFR-targeting peptide with improved tumor penetration');
