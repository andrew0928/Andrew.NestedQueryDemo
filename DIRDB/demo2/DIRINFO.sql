CREATE TABLE [demo2].[DIRINFO] (
    [ID]   INT            IDENTITY (1, 1) NOT NULL,
    [NAME] NVARCHAR (400) NOT NULL,
    [ID01] INT            NULL,
    [ID02] INT            NULL,
    [ID03] INT            NULL,
    [ID04] INT            NULL,
    [ID05] INT            NULL,
    [ID06] INT            NULL,
    [ID07] INT            NULL,
    [ID08] INT            NULL,
    [ID09] INT            NULL,
    [ID10] INT            NULL,
    [ID11] INT            NULL,
    [ID12] INT            NULL,
    [ID13] INT            NULL,
    [ID14] INT            NULL,
    [ID15] INT            NULL,
    [ID16] INT            NULL,
    [ID17] INT            NULL,
    [ID18] INT            NULL,
    [ID19] INT            NULL,
    [ID20] INT            NULL,
    CONSTRAINT [PK_DIRINFO_1] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_DIRINFO3]
    ON [demo2].[DIRINFO]([ID03] ASC)
    INCLUDE([NAME], [ID01], [ID02], [ID04], [ID05], [ID06], [ID07], [ID08], [ID09], [ID10], [ID11], [ID12], [ID13], [ID14], [ID15], [ID16], [ID17], [ID18], [ID19], [ID20]);


GO
CREATE NONCLUSTERED INDEX [IX_DIRINFO1]
    ON [demo2].[DIRINFO]([ID02] ASC, [ID03] ASC)
    INCLUDE([NAME], [ID01], [ID04], [ID05], [ID06], [ID07], [ID08], [ID09], [ID10], [ID11], [ID12], [ID13], [ID14], [ID15], [ID16], [ID17], [ID18], [ID19], [ID20]);


GO
CREATE NONCLUSTERED INDEX [IX_DIRINFO_2]
    ON [demo2].[DIRINFO]([NAME] ASC);

