/******************************************************************************
  @file    util.c
  @brief   some utils for this QCM tool.

  DESCRIPTION
  Connectivity Management Tool for USB network adapter of Quectel wireless cellular modules.

  INITIALIZATION AND SEQUENCING REQUIREMENTS
  None.

  ---------------------------------------------------------------------------
  Copyright (c) 2016 - 2020 Quectel Wireless Solution, Co., Ltd.  All Rights Reserved.
  Quectel Wireless Solution Proprietary and Confidential.
  ---------------------------------------------------------------------------
******************************************************************************/

#include <sys/time.h>
#include <net/if.h>

#if defined(__STDC__)
#include <stdarg.h>
#define __V(x)	x
#else
#include <varargs.h>
#define __V(x)	(va_alist) va_dcl
#define const
#define volatile
#endif

#include <syslog.h>

#include "QMIThread.h"

static void setTimespecRelative(struct timespec *p_ts, long long msec)
{
    struct timeval tv;

    gettimeofday(&tv, (struct timezone *) NULL);

    /* what's really funny about this is that I know
       pthread_cond_timedwait just turns around and makes this
       a relative time again */
    p_ts->tv_sec = tv.tv_sec + (msec / 1000);
    p_ts->tv_nsec = (tv.tv_usec + (msec % 1000) * 1000L ) * 1000L;
    if ((unsigned long)p_ts->tv_nsec >= 1000000000UL) {
        p_ts->tv_sec += 1;
        p_ts->tv_nsec -= 1000000000UL;
    }
}

int pthread_cond_timeout_np(pthread_cond_t *cond, pthread_mutex_t * mutex, unsigned msecs) {
    if (msecs != 0) {
        unsigned i;
        unsigned t = msecs/4;
        int ret = 0;

        if (t == 0)
            t = 1;

        for (i = 0; i < msecs; i += t) {
            struct timespec ts;
            setTimespecRelative(&ts, t);
            ret = pthread_cond_timedwait(cond, mutex, &ts); //to advoid system time change
            if (ret != ETIMEDOUT) {
                if(ret) dbg_time("ret=%d, msecs=%u, t=%u", ret, msecs, t);
                break;
            }
        }

        return ret;
    } else {
        return pthread_cond_wait(cond, mutex);
    }
}

void cond_setclock_attr(pthread_cond_t *cond, clockid_t clock)
{
#if 0 //very old uclibc do not support pthread_condattr_setclock
    /* set relative time, for pthread_cond_timedwait */
    pthread_condattr_t attr;
    pthread_condattr_init (&attr);
    pthread_condattr_setclock(&attr, clock);
    pthread_cond_init(cond, &attr);
    pthread_condattr_destroy (&attr);
#else
    (void)cond;
    (void)clock;
#endif
}

const char * get_time(void) {
    static char time_buf[50];
    struct timeval  tv;
    time_t time;
    suseconds_t millitm;
    struct tm *ti;

    gettimeofday (&tv, NULL);

    time= tv.tv_sec;
    millitm = (tv.tv_usec + 500) / 1000;

    if (millitm == 1000) {
        ++time;
        millitm = 0;
    }

    ti = localtime(&time);
    sprintf(time_buf, "%02d-%02d_%02d:%02d:%02d:%03d", ti->tm_mon+1, ti->tm_mday, ti->tm_hour, ti->tm_min, ti->tm_sec, (int)millitm);
    return time_buf;
}

unsigned long clock_msec(void)
{
	struct timespec tm;
	clock_gettime( CLOCK_MONOTONIC, &tm);
	return (unsigned long)(tm.tv_sec*1000 + (tm.tv_nsec/1000000));
}

FILE *logfilefp = NULL;

const int i = 1;
#define is_bigendian() ( (*(char*)&i) == 0 )

USHORT le16_to_cpu(USHORT v16) {
    USHORT tmp = v16;
    if (is_bigendian()) {
        unsigned char *s = (unsigned char *)(&v16);
        unsigned char *d = (unsigned char *)(&tmp);
        d[0] = s[1];
        d[1] = s[0];
    }
    return tmp;
}

UINT  le32_to_cpu (UINT v32) {
    UINT tmp = v32;
    if (is_bigendian()) {
        unsigned char *s = (unsigned char *)(&v32);
        unsigned char *d = (unsigned char *)(&tmp);
        d[0] = s[3];
        d[1] = s[2];
        d[2] = s[1];
        d[3] = s[0];
    }
    return tmp;
}

UINT ql_swap32(UINT v32) {
    UINT tmp = v32;
    {
        unsigned char *s = (unsigned char *)(&v32);
        unsigned char *d = (unsigned char *)(&tmp);
        d[0] = s[3];
        d[1] = s[2];
        d[2] = s[1];
        d[3] = s[0];
    }
    return tmp;
}

USHORT cpu_to_le16(USHORT v16) {
    USHORT tmp = v16;
    if (is_bigendian()) {
        unsigned char *s = (unsigned char *)(&v16);
        unsigned char *d = (unsigned char *)(&tmp);
        d[0] = s[1];
        d[1] = s[0];
    }
    return tmp;
}

UINT cpu_to_le32 (UINT v32) {
    UINT tmp = v32;
    if (is_bigendian()) {
        unsigned char *s = (unsigned char *)(&v32);
        unsigned char *d = (unsigned char *)(&tmp);
        d[0] = s[3];
        d[1] = s[2];
        d[2] = s[1];
        d[3] = s[0];
    }
    return tmp;
}

void update_resolv_conf(int iptype, const char *ifname, const char *dns1, const char *dns2) {
    const char *dns_file = "/etc/resolv.conf";
    FILE *dns_fp;
    char dns_line[256];
    #define MAX_DNS 16
    char *dns_info[MAX_DNS];
    char dns_tag[64];
    int dns_match = 0;
    int i;

    snprintf(dns_tag, sizeof(dns_tag), "# IPV%d %s", iptype, ifname);

    for (i = 0; i < MAX_DNS; i++)
        dns_info[i] = NULL;
    
    dns_fp = fopen(dns_file, "r");
    if (dns_fp) {
        i = 0;    
        dns_line[sizeof(dns_line)-1] = '\0';
        
        while((fgets(dns_line, sizeof(dns_line)-1, dns_fp)) != NULL) {
            if ((strlen(dns_line) > 1) && (dns_line[strlen(dns_line) - 1] == '\n'))
                dns_line[strlen(dns_line) - 1] = '\0';
            //dbg_time("%s", dns_line);
            if (strstr(dns_line, dns_tag)) {
                dns_match++;
                continue;
            }
            dns_info[i++] = strdup(dns_line);
            if (i == MAX_DNS)
                break;
        }

        fclose(dns_fp);
    }
    else if (errno != ENOENT) {
        dbg_time("fopen %s fail, errno:%d (%s)", dns_file, errno, strerror(errno));
        return;
    }
    
    if (dns1 == NULL && dns_match == 0)
        return;

    dns_fp = fopen(dns_file, "w");
    if (dns_fp) {
        if (dns1)
            fprintf(dns_fp, "nameserver %s %s\n", dns1, dns_tag);
        if (dns2)
            fprintf(dns_fp, "nameserver %s %s\n", dns2, dns_tag);
        
        for (i = 0; i < MAX_DNS && dns_info[i]; i++)
            fprintf(dns_fp, "%s\n", dns_info[i]);
        fclose(dns_fp);
    }
    else {
        dbg_time("fopen %s fail, errno:%d (%s)", dns_file, errno, strerror(errno));
    }

    for (i = 0; i < MAX_DNS && dns_info[i]; i++)
        free(dns_info[i]);
}

pid_t getpid_by_pdp(int pdp, const char* program_name)
{
    glob_t gt;
    int ret;
    char filter[5] = {0};
    pid_t pid;

    sprintf(filter, "-n %d", pdp);
    ret = glob("/proc/*/cmdline", GLOB_NOSORT, NULL, &gt);
    if (ret != 0) {
        dbg_time("glob error, errno = %d(%s)", errno, strerror(errno));
		return -1;
    } else {
        int i = 0, fd = -1;
        ssize_t nreads;
        char cmdline[512] = {0};

		for (i = 0; i < (int)gt.gl_pathc; i++) {
            fd = open(gt.gl_pathv[i], O_RDONLY);
            if (fd == -1) {
                dbg_time("open %s failed, errno = %d(%s)", gt.gl_pathv[i], errno, strerror(errno));
                globfree(&gt);
                return -1;
            }
            
            nreads = read(fd, cmdline, sizeof(cmdline));
            if (nreads > 0) {
                int pos = 0;
                while (pos < nreads-1) {
                    if (cmdline[pos] == '\0')
                        cmdline[pos] = ' ';  // space
                    pos++;
                }
                // printf("%s\n", cmdline);
            }

            if (strstr(cmdline, program_name) && strstr(cmdline, filter)) {
            	char path[64] = {0};
            	char pidstr[64] = {0};
            	char *p;
            	
                dbg_time("%s: %s", gt.gl_pathv[i], cmdline);
            	strcpy(path, gt.gl_pathv[i]);
            	p = strstr(gt.gl_pathv[i], "/cmdline");
            	*p = '\0';
            	while (*(--p) != '/') ;
            		
            	strcpy(pidstr, p+1);
            	pid = atoi(pidstr);
            	globfree(&gt);
                
                return pid;
            }
        }
    }

    globfree(&gt);
    return -1;
}

void ql_get_driver_rmnet_info(PROFILE_T *profile, RMNET_INFO *rmnet_info) {
    int ifc_ctl_sock;
    struct ifreq ifr;
    int rc;
    int request = 0x89F3;
    unsigned char data[512];

    memset(rmnet_info, 0x00, sizeof(*rmnet_info));

    ifc_ctl_sock = socket(AF_INET, SOCK_DGRAM, 0);
    if (ifc_ctl_sock <= 0) {
        dbg_time("socket() failed: %s\n", strerror(errno));
        return;
    }
    
    memset(&ifr, 0, sizeof(struct ifreq));
    strncpy(ifr.ifr_name, profile->usbnet_adapter, IFNAMSIZ);
    ifr.ifr_name[IFNAMSIZ - 1] = 0;    
    ifr.ifr_ifru.ifru_data = (void *)data;
        
    rc = ioctl(ifc_ctl_sock, request, &ifr);
    if (rc < 0) {
        dbg_time("ioctl(0x%x, qmap_settings) failed: %s, rc=%d", request, strerror(errno), rc);
    }
    else {
        memcpy(rmnet_info, data, sizeof(*rmnet_info));
    }

    close(ifc_ctl_sock);
}

void ql_set_driver_qmap_setting(PROFILE_T *profile, QMAP_SETTING *qmap_settings) {
    int ifc_ctl_sock;
    struct ifreq ifr;
    int rc;
    int request = 0x89F2;

    ifc_ctl_sock = socket(AF_INET, SOCK_DGRAM, 0);
    if (ifc_ctl_sock <= 0) {
        dbg_time("socket() failed: %s\n", strerror(errno));
        return;
    }
    
    memset(&ifr, 0, sizeof(struct ifreq));
    strncpy(ifr.ifr_name, profile->usbnet_adapter, IFNAMSIZ);
    ifr.ifr_name[IFNAMSIZ - 1] = 0;    
    ifr.ifr_ifru.ifru_data = (void *)qmap_settings;
        
    rc = ioctl(ifc_ctl_sock, request, &ifr);
    if (rc < 0) {
        dbg_time("ioctl(0x%x, qmap_settings) failed: %s, rc=%d", request, strerror(errno), rc);
    }

    close(ifc_ctl_sock);	
}
