################
## An R function to reshape a vectorized symetric square matrix back to matrix.
##

vec_to_matrix=function(dt){
        snp_id=unique(c(dt[,1],dt[,2]))
        snp_ll=length(snp_id)
        dm=matrix(1,nrow=snp_ll, ncol=snp_ll)

        ####make a index
        s_idx=list()
        for (i in 1:snp_ll){
                s_idx[[i]]=unique(c(which(dt[,2]==snp_id[i]),which(dt[,1]==snp_id[i])))
        }

        for (i in 1:(snp_ll-1)){
                for (j in (i+1):snp_ll){

                        s_scope=unique(c(s_idx[[i]], s_idx[[j]]))
                        dt_s=dt[s_scope,]

                        f_idx=subset(dt_s, (dt_s[,1]==snp_id[i] & dt_s[,2]==snp_id[j]) | (dt_s[,1]==snp_id[j] & dt_s[,2]==snp_id[i]) )
                        if (length(f_idx[,1])>0){
                                dm[i,j]=f_idx[1,3]
                                dm[j,i]=f_idx[1,3]
                        }else{
                                dm[i,j]=0
                                dm[j,i]=0
                        }

                }
        }

        rownames(dm)=snp_id
        colnames(dm)=snp_id
        return(dm)
}
