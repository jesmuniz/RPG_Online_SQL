/* ============================================================
   Projeto: RPG Online
   Banco de dados: RPG_Online
   SGBD: Microsoft SQL Server
   Descricao: Criacao das tabelas, chaves primarias e estrangeiras
              conforme o diagrama entidade-relacionamento da atividade.
   ============================================================ */

/* 1. Criar o banco de dados caso ainda nao exista */
IF DB_ID(N'RPG_Online') IS NULL
BEGIN
    EXEC(N'CREATE DATABASE [RPG_Online]');
END;
GO

/* 2. Selecionar o banco de dados */
USE [RPG_Online];
GO

/* 3. Tabela USUARIOS
      Um usuario pode possuir varios personagens (1:N). */
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

/* 4. Tabela CLASSES
      Uma classe pode estar associada a varios personagens
      e a varias habilidades. */
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

/* 5. Tabela HABILIDADES
      Uma habilidade pode estar associada a varias classes. */
IF OBJECT_ID(N'dbo.HABILIDADES', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.HABILIDADES (
        HabilidadeId INT IDENTITY(1,1) NOT NULL,
        Nome VARCHAR(100) NOT NULL,
        CONSTRAINT PK_HABILIDADES PRIMARY KEY (HabilidadeId)
    );
END;
GO

/* 6. Tabela PERSONAGENS
      Cada personagem pertence a um usuario e a uma classe.
      USUARIOS 1:N PERSONAGENS
      CLASSES  1:N PERSONAGENS */
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

/* 7. Tabela CLASSES_HABILIDADES
      Tabela associativa que resolve o relacionamento N:N
      entre CLASSES e HABILIDADES.
      A chave primaria composta impede repetir a mesma
      combinacao de classe e habilidade. */
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

/* 8. Consultas de verificacao da estrutura criada */
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
