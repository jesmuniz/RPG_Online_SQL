
IF DB_ID(N'RPG_Online') IS NULL
BEGIN
    EXEC(N'CREATE DATABASE [RPG_Online]');
END;
GO

USE [RPG_Online];
GO

IF OBJECT_ID(N'dbo.USUARIOS', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.USUARIOS (
        UsuarioId INT IDENTITY(1,1) NOT NULL,
        Email VARCHAR(150) NOT NULL,
        Senha VARCHAR(255) NOT NULL,
        CONSTRAINT PK_USUARIOS PRIMARY KEY (UsuarioId)
    );
END;
GO

IF OBJECT_ID(N'dbo.CLASSES', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.CLASSES (
        ClasseId INT IDENTITY(1,1) NOT NULL,
        Nome VARCHAR(100) NOT NULL,
        Descricao VARCHAR(255) NOT NULL,
        CONSTRAINT PK_CLASSES PRIMARY KEY (ClasseId)
    );
END;
GO

IF OBJECT_ID(N'dbo.HABILIDADES', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.HABILIDADES (
        HabilidadeId INT IDENTITY(1,1) NOT NULL,
        Nome VARCHAR(100) NOT NULL,
        CONSTRAINT PK_HABILIDADES PRIMARY KEY (HabilidadeId)
    );
END;
GO

IF OBJECT_ID(N'dbo.PERSONAGENS', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.PERSONAGENS (
        PersonagemId INT IDENTITY(1,1) NOT NULL,
        NomePersonagem VARCHAR(100) NOT NULL,
        UsuarioId INT NOT NULL,
        ClasseId INT NOT NULL,
        CONSTRAINT PK_PERSONAGENS PRIMARY KEY (PersonagemId),
        CONSTRAINT FK_PERSONAGENS_USUARIOS
            FOREIGN KEY (UsuarioId)
            REFERENCES dbo.USUARIOS (UsuarioId),
        CONSTRAINT FK_PERSONAGENS_CLASSES
            FOREIGN KEY (ClasseId)
            REFERENCES dbo.CLASSES (ClasseId)
    );
END;
GO

IF OBJECT_ID(N'dbo.CLASSES_HABILIDADES', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.CLASSES_HABILIDADES (
        ClasseId INT NOT NULL,
        HabilidadeId INT NOT NULL,
        CONSTRAINT PK_CLASSES_HABILIDADES
            PRIMARY KEY (ClasseId, HabilidadeId),
        CONSTRAINT FK_CLASSES_HABILIDADES_CLASSES
            FOREIGN KEY (ClasseId)
            REFERENCES dbo.CLASSES (ClasseId),
        CONSTRAINT FK_CLASSES_HABILIDADES_HABILIDADES
            FOREIGN KEY (HabilidadeId)
            REFERENCES dbo.HABILIDADES (HabilidadeId)
    );
END;
GO

SELECT TABLE_NAME AS Tabela
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
  AND TABLE_SCHEMA = 'dbo'
ORDER BY TABLE_NAME;
GO

SELECT
    fk.name AS NomeDaChaveEstrangeira,
    OBJECT_NAME(fk.parent_object_id) AS TabelaOrigem,
    OBJECT_NAME(fk.referenced_object_id) AS TabelaReferenciada
FROM sys.foreign_keys AS fk
ORDER BY TabelaOrigem, NomeDaChaveEstrangeira;
GO

SELECT
    t.name AS Tabela,
    c.name AS Coluna,
    kc.name AS NomeDaChave,
    ic.key_ordinal AS OrdemNaChave
FROM sys.key_constraints AS kc
INNER JOIN sys.tables AS t
    ON kc.parent_object_id = t.object_id
INNER JOIN sys.index_columns AS ic
    ON kc.parent_object_id = ic.object_id
   AND kc.unique_index_id = ic.index_id
INNER JOIN sys.columns AS c
    ON ic.object_id = c.object_id
   AND ic.column_id = c.column_id
WHERE kc.type = 'PK'
ORDER BY t.name, ic.key_ordinal;
GO
