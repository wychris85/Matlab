function  Z = mergeMatFile(matFile1, matFile2)

S = load(matFile1);
T = load(matFile2);
Z = cell2struct(cellfun(@horzcat,struct2cell(S),struct2cell(T),'uni',0),fieldnames(S),1);

end