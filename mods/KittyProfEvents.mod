    {
        passage: "EventProfessorHelpDeskOral",
        tags: ["professor help", "office"],
        frequency: 50,
        checkvar: 'setup.people.professor_intimacy($eventnpc) gte 2 and (["Disciplinarian Professor", "Intense Professor"].includes(setup.people.professor_reaction($eventnpc)) or $eventmemory["EventProfessorHelpDeskOral"])',
    },
    {
        passage: "EventProfessorSex",
        tags: ["professor help", "office", "class"],
        frequency: 50,
        "days since": 3,
        checkvar: 'setup.people.attracted_enough_to_pc($eventnpc) and setup.people.professor_intimacy($eventnpc) is 2 and setup.people.get_attitude($eventnpc, "lust") gte setup.people.professor_lust_threshold($eventnpc)',
    },

    // increment professor intimacy
    {
        passage: "EventProfessorVoyeur",
        tags: ["professor help", "office", "class"],
        frequency: 200,
        "days since": 6,
        checkvar: 'setup.people.pc_attracted_to($eventnpc) and setup.people.attracted_enough_to_pc($eventnpc) and setup.people.professor_intimacy($eventnpc) is 0 and ["Disciplinarian Professor", "Intense Professor"].includes(setup.people.professor_reaction($eventnpc)) and setup.people.get_attitude($eventnpc, "lust") gte (setup.people.professor_lust_threshold($eventnpc) / 2)',
    },
    {
        passage: "EventProfessorExhib",
        tags: ["professor help", "office", "class"],
        frequency: 200,
        "days since": 6,
        checkvar: 'setup.people.pc_attracted_to($eventnpc) and setup.people.attracted_enough_to_pc($eventnpc) and setup.people.professor_intimacy($eventnpc) is 0 and ["Married Professor", "New Professor"].includes(setup.people.professor_reaction($eventnpc)) and setup.people.get_attitude($eventnpc, "lust") gte (setup.people.professor_lust_threshold($eventnpc) / 2)',
    },
    {
        passage: "EventProfessorSex",
        tags: ["professor help", "office", "class"],
        frequency: 200,
        "days since": 6,
        checkvar: 'setup.people.pc_attracted_to($eventnpc) and setup.people.attracted_enough_to_pc($eventnpc) and setup.people.professor_intimacy($eventnpc) is 1 and setup.people.get_attitude($eventnpc, "lust") gte setup.people.professor_lust_threshold($eventnpc)',
    },~    {
        passage: "EventProfessorHelpDeskOral",
        tags: ["professor help", "office"],
        frequency: 1250,
        checkvar: 'setup.people.professor_intimacy($eventnpc) gte 2 and (["Disciplinarian Professor", "Intense Professor"].includes(setup.people.professor_reaction($eventnpc)) or $eventmemory["EventProfessorHelpDeskOral"])',
    },
    {
        passage: "EventProfessorSex",
        tags: ["professor help", "office", "class"],
        frequency: 1250,
        "days since": 0,
        checkvar: 'setup.people.attracted_enough_to_pc($eventnpc) and setup.people.professor_intimacy($eventnpc) is 2 and setup.people.get_attitude($eventnpc, "lust") gte setup.people.professor_lust_threshold($eventnpc)',
    },

    // increment professor intimacy
    {
        passage: "EventProfessorVoyeur",
        tags: ["professor help", "office", "class"],
        frequency: 600,
        "days since": 0,
        checkvar: 'setup.people.pc_attracted_to($eventnpc) and setup.people.attracted_enough_to_pc($eventnpc) and setup.people.professor_intimacy($eventnpc) is 0 and ["Disciplinarian Professor", "Intense Professor"].includes(setup.people.professor_reaction($eventnpc)) and setup.people.get_attitude($eventnpc, "lust") gte (setup.people.professor_lust_threshold($eventnpc) / 2)',
    },
    {
        passage: "EventProfessorExhib",
        tags: ["professor help", "office", "class"],
        frequency: 600,
        "days since": 0,
        checkvar: 'setup.people.pc_attracted_to($eventnpc) and setup.people.attracted_enough_to_pc($eventnpc) and setup.people.professor_intimacy($eventnpc) is 0 and ["Married Professor", "New Professor"].includes(setup.people.professor_reaction($eventnpc)) and setup.people.get_attitude($eventnpc, "lust") gte (setup.people.professor_lust_threshold($eventnpc) / 2)',
    },
    {
        passage: "EventProfessorSex",
        tags: ["professor help", "office", "class"],
        frequency: 1200,
        "days since": 0,
        checkvar: 'setup.people.pc_attracted_to($eventnpc) and setup.people.attracted_enough_to_pc($eventnpc) and setup.people.professor_intimacy($eventnpc) is 1 and setup.people.get_attitude($eventnpc, "lust") gte setup.people.professor_lust_threshold($eventnpc)',
    },