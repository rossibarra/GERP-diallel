# Jinliang Yang
# updated: Jan 25th, 2016
# run the wholeset with all GERP SNPs

source("lib/slurm4GenSel.R")
source("~/Documents/Github/zmSNPtools/Rcodes/set_arrayjob.R")
setup_newbin_array <- function(
  ### note: it is for 7 traits with 3 modes for one random shuffling or real data
  genobase="largedata/SNP/geno_b0_cs/gerpv2_b0_cs0", 
  jobdir="slurm-scripts/get_newbin", inpbase= "cs0",
  ptype="pBPHmax", priors,
  jobbase="run_newbin_job", jobid =1){
  
  ### prior information
  wd <- getwd()
  #test run of the 66 diallel of trait per se with additive model
  ti <- tolower(c("ASI", "DTP", "DTS", "EHT",  "GY", "PHT",  "TW"))
  res <- c(0.38, 0.46, 0.46, 15, 88, 41, 0.64)
  gen <- c(0.18, 5.1, 6.0, 123, 65, 377, 0.82)
  
  dir.create(jobdir, showWarnings = FALSE)
  shcommand <- c()
  for(myti in 1:7){
    for(modei in "h2"){
        
      ### the first one use gs
      myinp <- paste0(jobdir, "/", inpbase, "_", ti[myti], "_", modei,"_ws", ".inp")
      GenSel_inp(
        inp= myinp, pi=0.99,
        findsale ="no",
        geno=paste0(wd, "/", genobase, "/", ti[myti], "_k_", modei, ".gs.newbin"), 
        pheno=paste0(wd, "/largedata/pheno/wholeset/", tolower(ti[myti]), "_", ptype, ".txt"),
        chainLength=41000, burnin=1000, 
        #varGenotypic = gen[myti], 
        #varResidual = res[myti]
        varGenotypic = subset(priors, trait == ti[myti] & mode == modei)$genvar, 
        varResidual = subset(priors, trait == ti[myti] & mode == modei)$resvar
      )
      shcommand <- c(shcommand, paste("GenSel4R", myinp))
    }
  }
  #################
  jobstart = jobid
  for(i in 1:length(shcommand)){
    cat(shcommand[i], file=paste0(jobdir, "/", jobbase, jobid, ".sh"), sep="\n", append=FALSE)
    jobid <- jobid + 1
  }
  jobend <- jobid -1
  message(sprintf("###>>> setup array jobs: [ %s - %s]", jobstart, jobend))
  set_arrayjob(shid=paste0(jobdir, "/", jobbase, ".sh"),
               shcode=paste0("sh ", jobdir, "/", jobbase, "$SLURM_ARRAY_TASK_ID.sh"),
               arrayjobs= paste0("1-", jobend),
               wd=NULL, jobid=jobbase, email="yangjl0930@gmail.com")
  
}

###########
#newbin_array_7traits_3modes(genobase="largedata/SNP/geno_b0_cs/gerpv2_b0_cs0",
p1 <- read.csv("cache/gerpsnp_wholeset_perse.csv")
setup_newbin_array(
  ### note: it is for 7 traits with 3 modes for one random shuffling or real data
  genobase="largedata/sgeno_100k", 
  ptype="perse", prior=p1,
  jobdir="slurm-script/subgeno", inpbase= "ws",
  jobbase="run_ws", jobid =1)

###>>> setup array jobs: [ 1 - 7]
###>>> In this path: cd /home/jolyang/Documents/Github/GERP-diallel
###>>> [ note: --ntasks=INT, number of cup ]
###>>> [ note: --mem=16000, 16G memory ]
###>>> RUN: sbatch -p bigmemh --time=8:00:00 slurm-script/subgeno/run_ws.sh







source("lib/slurm4GenSel.R")
source("~/Documents/Github/zmSNPtools/Rcodes/set_arrayjob.R")
setup_newbin_array <- function(
    ### note: it is for 7 traits with 3 modes for one random shuffling or real data
    genopwd="largedata/SNP/geno_b0_cs/", 
    jobdir="slurm-scripts/get_newbin", inpbase= "cs0",
    ptype="pBPHmax", priors,
    jobbase="run_newbin_job", jobid =1){
    
    ### prior information
    wd <- getwd()
    #test run of the 66 diallel of trait per se with additive model
    ti <- tolower(c("ASI", "DTP", "DTS", "EHT",  "GY", "PHT",  "TW"))
    res <- c(0.38, 0.46, 0.46, 15, 88, 41, 0.64)
    gen <- c(0.18, 5.1, 6.0, 123, 65, 377, 0.82)
    
    dir.create(jobdir, showWarnings = FALSE)
    shcommand <- c()
    
    genos <- list.files(path=genopwd, pattern="newbin", full.names = TRUE)
    
    for(myti in 1:7){
        for(modei in "h2"){
            
            ### the first one use gs
            myinp <- paste0(jobdir, "/", inpbase, "_", ti[myti], "_", modei,"_ws", ".inp")
            GenSel_inp(
                inp= myinp, pi=0.99,
                findsale ="no",
                geno=paste0(wd, "/", genobase, "/", ti[myti], "_k_", modei, ".gs.newbin"), 
                pheno=paste0(wd, "/largedata/pheno/wholeset/", tolower(ti[myti]), "_", ptype, ".txt"),
                chainLength=41000, burnin=1000, 
                #varGenotypic = gen[myti], 
                #varResidual = res[myti]
                varGenotypic = subset(priors, trait == ti[myti] & mode == modei)$genvar, 
                varResidual = subset(priors, trait == ti[myti] & mode == modei)$resvar
            )
            shcommand <- c(shcommand, paste("GenSel4R", myinp))
        }
    }
    #################
    jobstart = jobid
    for(i in 1:length(shcommand)){
        cat(shcommand[i], file=paste0(jobdir, "/", jobbase, jobid, ".sh"), sep="\n", append=FALSE)
        jobid <- jobid + 1
    }
    jobend <- jobid -1
    message(sprintf("###>>> setup array jobs: [ %s - %s]", jobstart, jobend))
    set_arrayjob(shid=paste0(jobdir, "/", jobbase, ".sh"),
                 shcode=paste0("sh ", jobdir, "/", jobbase, "$SLURM_ARRAY_TASK_ID.sh"),
                 arrayjobs= paste0("1-", jobend),
                 wd=NULL, jobid=jobbase, email="yangjl0930@gmail.com")
    
}

###########
#newbin_array_7traits_3modes(genobase="largedata/SNP/geno_b0_cs/gerpv2_b0_cs0",
p1 <- read.csv("cache/gerpsnp_wholeset_perse.csv")
setup_newbin_array(
    ### note: it is for 7 traits with 3 modes for one random shuffling or real data
    genobase="largedata/sgeno", 
    ptype="perse", prior=p1,
    jobdir="slurm-script/sub_rand_geno", inpbase= "ws",
    jobbase="run_random", jobid =1)

####>>> setup array jobs: [ 1 - 7]
###>>> In this path: cd /home/jolyang/Documents/Github/GERP-diallel
###>>> [ note: --ntasks=INT, number of cup ]
###>>> [ note: --mem=16000, 16G memory ]
###>>> RUN: sbatch -p bigmemh slurm-script/sub_rand_geno/run_random.sh
###>>> RUN: sbatch -p bigmemh --time=8:00:00 slurm-script/subgeno/run_ws.sh



