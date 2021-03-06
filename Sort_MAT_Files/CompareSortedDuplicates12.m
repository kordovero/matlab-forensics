In_Base='/media/marzampoglou/3TB/Recovery/Recuva/Excellent/Folders/folder_mat/';
FolderIn='12/Tw';
NameSuffix='_Tw';

SortedOutDir=['/media/marzampoglou/3TB/Recovery/Recuva/Excellent/Folders/folder_mat/SortedOut/' FolderIn '/'];
mkdir(SortedOutDir);

Out_Base='/media/marzampoglou/New_NTFS_Volume/markzampoglou/ImageForensics/AlgorithmOutput/';
FolderOut='12 - Kurtosis - Exposing Region Splicing Forgeries with Blind Local Noise Estimation/';
Quality=75;
Rescale=false;

FinalOutputFolder=[Out_Base FolderOut num2str(Quality) '_' num2str(Rescale) '/'];

InList=dir([In_Base FolderIn '/*.mat']);

DuplicatesFolderBase='/media/marzampoglou/3TB/Recovery/Recuva/Excellent/Folders/folder_mat/Duplicates/';
DuplicatesDir=[DuplicatesFolderBase FolderIn '/'];
mkdir(DuplicatesDir);

for ii=1:length(InList)
    Loaded=load([In_Base FolderIn '/' InList(ii).name]);
    if strcmp(Loaded.Name(1:3),'D:\')
        Slashes=strfind(Loaded.Name,'\');
    else
        Slashes=strfind(Loaded.Name,'/');
    end
    Loaded.Name=strrep(Loaded.Name,'\','/');
    if ~isempty(Slashes)>0
        FinalSlash=Slashes(end);
        
        Dots=strfind(Loaded.Name,'.');
        FinalDot=Dots(end);
        
        OutBaseInd=strfind(Loaded.Name,'TwJPEG/')+7;
        
        
        SubFolderStructure=Loaded.Name(OutBaseInd:FinalSlash);
        if ~exist([FinalOutputFolder SubFolderStructure], 'dir')
            mkdir([FinalOutputFolder SubFolderStructure]);
        end
        
        
        PlainName=Loaded.Name(FinalSlash+1:FinalDot-1);
        PlainName=strrep(PlainName,NameSuffix,'');
        PlainName=[PlainName Loaded.Name(FinalDot:end)];
        
        
        BinMask=Loaded.BinMask;
        Name=[SubFolderStructure PlainName];
        Result=Loaded.Result;
        
        if ~exist([FinalOutputFolder SubFolderStructure PlainName '.mat'],'file')
            %save([FinalOutputFolder SubFolderStructure PlainName '.mat'], 'BinMask', 'Name', 'Result', 'Quality', 'Rescale', '-v7.3');
            %system(['mv ' In_Base FolderIn '/' InList(ii).name ' ' SortedOutDir]);
            disp('unique!');
        else
            LExist=load([FinalOutputFolder SubFolderStructure PlainName '.mat']);
            
            if isfield(Loaded.Result,'estVRand') & ~isfield(LExist.Result,'estVRand')
                disp('Sorted has no random');
            elseif ~isfield(Loaded.Result,'estVRand') & isfield(LExist.Result,'estVRand')
                disp('Loaded has no random');
            elseif numel(Loaded.Result.estVRand)<numel(LExist.Result.estVRand)
                disp('Loaded has fewer elements');
                LExist.Result.estVDCT(isnan(LExist.Result.estVDCT))=-666.4242666;
                LExist.Result.estVHaar(isnan(LExist.Result.estVHaar))=-666.4242666;
                
                Loaded.Result.estVDCT(isnan(Loaded.Result.estVDCT))=-666.4242666;
                Loaded.Result.estVHaar(isnan(Loaded.Result.estVHaar))=-666.4242666;
                if ~sum(sum(sum(LExist.Result.estVDCT~=Loaded.Result.estVDCT))) && ~sum(sum(sum(LExist.Result.estVHaar~=Loaded.Result.estVHaar)))
                    system(['mv ' In_Base FolderIn '/' InList(ii).name ' ' DuplicatesDir]);
                end                
            elseif numel(Loaded.Result.estVRand)>numel(LExist.Result.estVRand)
                disp('Loaded has more elements');
                LExist.Result.estVDCT(isnan(LExist.Result.estVDCT))=-666.4242666;
                LExist.Result.estVHaar(isnan(LExist.Result.estVHaar))=-666.4242666;
                
                Loaded.Result.estVDCT(isnan(Loaded.Result.estVDCT))=-666.4242666;
                Loaded.Result.estVHaar(isnan(Loaded.Result.estVHaar))=-666.4242666;
                if ~sum(sum(sum(LExist.Result.estVDCT~=Loaded.Result.estVDCT))) && ~sum(sum(sum(LExist.Result.estVHaar~=Loaded.Result.estVHaar)))
                    system(['mv ' In_Base FolderIn '/' InList(ii).name ' ' DuplicatesDir]);
                end
            else
                LExist.Result.estVDCT(isnan(LExist.Result.estVDCT))=-666.4242666;
                LExist.Result.estVHaar(isnan(LExist.Result.estVHaar))=-666.4242666;
                LExist.Result.estVRand(isnan(LExist.Result.estVRand))=-666.4242666;
                
                Loaded.Result.estVDCT(isnan(Loaded.Result.estVDCT))=-666.4242666;
                Loaded.Result.estVHaar(isnan(Loaded.Result.estVHaar))=-666.4242666;
                Loaded.Result.estVRand(isnan(Loaded.Result.estVRand))=-666.4242666;
                
                
                
                if ~sum(sum(sum(LExist.Result.estVDCT~=Loaded.Result.estVDCT))) && ~sum(sum(sum(LExist.Result.estVHaar~=Loaded.Result.estVHaar))) && ~sum(sum(sum(LExist.Result.estVRand~=Loaded.Result.estVRand)))
                    system(['mv ' In_Base FolderIn '/' InList(ii).name ' ' DuplicatesDir]);
                else
                    disp(['File not identical! ' FinalOutputFolder SubFolderStructure PlainName '.mat']);
                end
            end
        end
    else
        disp(['No slashes! ' Loaded.Name]);
    end
end